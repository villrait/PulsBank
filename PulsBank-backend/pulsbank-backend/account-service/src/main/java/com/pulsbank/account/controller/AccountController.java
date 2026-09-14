package com.pulsbank.account.controller;

import com.pulsbank.account.dto.BalanceResponse;
import com.pulsbank.account.service.AccountService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Эндпоинты счета и баланса.
 */
@RestController
@RequestMapping("/account")
public class AccountController {

    private final AccountService accountService;

    public AccountController(AccountService accountService) {
        this.accountService = accountService;
    }

    /**
     * Возвращает баланс пользователя.
     */
    @GetMapping("/balance")
    public BalanceResponse balance(@RequestParam Long userId) {
        return new BalanceResponse(userId, accountService.getBalance(userId));
    }

    /**
     * Открывает счёт пользователю с начальным балансом 1000.00 (идемпотентно).
     * Позже этот эндпоинт будет вызываться auth-service при регистрации пользователя.
     */
    @PostMapping("/open")
    public BalanceResponse openAccount(@RequestParam Long userId) {
        accountService.createAccountForUser(userId);
        return new BalanceResponse(userId, accountService.getBalance(userId));
    }
}
