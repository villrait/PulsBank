package com.pulsbank.account.controller;

import com.pulsbank.account.dto.BalanceResponse;
import com.pulsbank.account.service.AccountService;
import org.springframework.web.bind.annotation.GetMapping;
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
}
