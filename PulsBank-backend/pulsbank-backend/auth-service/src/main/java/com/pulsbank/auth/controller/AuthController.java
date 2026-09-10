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
 *
 * <p>Пока без security/валидации/исключений — контроллер возвращает простой {@link AuthResponse}.</p>
 */
@RestController
@RequestMapping("/auth")
public class AuthController {
    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    /**
     * Регистрирует пользователя и создаёт ему счёт.
     *
     * <p>Создание счёта делегировано в мок-сервис (см. {@code MockUserService}).</p>
     */
    @PostMapping("/register")
    public AuthResponse register(@RequestBody RegisterRequest request) {
        User user = new User(null, request.getEmail(), request.getPassword());
        User saved = userService.save(user);
        return new AuthResponse(saved.getId(), saved.getEmail(), "registered");
    }

    /**
     * Проверяет email/password.
     *
     * <p>В случае ошибки намеренно не раскрываем, что именно неверно (email или пароль).</p>
     */
    @PostMapping("/login")
    public AuthResponse login(@RequestBody LoginRequest request) {
        User user = userService.findByEmail(request.getEmail());
        if (user == null) {
            return new AuthResponse(null, null, "invalid");
        }

        if (!user.getPassword().equals(request.getPassword())) {
            return new AuthResponse(null, null, "invalid");
        }

        return new AuthResponse(user.getId(), user.getEmail(), "ok");
    }
}
