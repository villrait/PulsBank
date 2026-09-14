package com.pulsbank.auth.controller;

import com.pulsbank.auth.dto.AuthResponse;
import com.pulsbank.auth.dto.LoginRequest;
import com.pulsbank.auth.dto.RegisterRequest;
import com.pulsbank.auth.model.User;
import com.pulsbank.auth.service.UserService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Эндпоинты регистрации и входа.
 * Регистрация и вход — по номеру телефона (как в реальных банках РФ).
 */
@RestController
@RequestMapping("/auth")
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    /**
     * Регистрирует клиента по номеру телефона и паролю.
     */
    @PostMapping("/register")
    public AuthResponse register(@RequestBody RegisterRequest request) {
        User user = new User(null, request.getPhone(), request.getPassword());
        User saved = userService.save(user);
        return new AuthResponse(saved.getId(), saved.getPhone(), "registered");
    }

    /**
     * Проверяет телефон/пароль.
     *
     * <p>В случае ошибки намеренно не раскрываем, что именно неверно (телефон или пароль).</p>
     */
    @PostMapping("/login")
    public AuthResponse login(@RequestBody LoginRequest request) {
        User user = userService.findByPhone(request.getPhone());
        if (user == null) {
            return new AuthResponse(null, null, "invalid");
        }
        if (!user.getPassword().equals(request.getPassword())) {
            return new AuthResponse(null, null, "invalid");
        }
        return new AuthResponse(user.getId(), user.getPhone(), "ok");
    }
}
