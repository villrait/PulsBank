package com.pulsbank.account.controller;

import com.pulsbank.account.dto.BalanceResponse;
import com.pulsbank.account.dto.TransferResult;
import com.pulsbank.account.service.AccountService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;

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
     * Открывает счёт пользователю с начальным балансом (идемпотентно).
     * Вызывается auth-service при регистрации клиента.
     */
    @PostMapping("/open")
    public BalanceResponse openAccount(@RequestParam Long userId) {
        accountService.createAccountForUser(userId);
        return new BalanceResponse(userId, accountService.getBalance(userId));
    }

    /**
     * Атомарно переводит сумму между счетами двух пользователей.
     * Вызывается transfer-service при переводе.
     */
    @PostMapping("/transfer")
    public TransferResult transfer(@RequestParam Long fromUserId,
                                   @RequestParam Long toUserId,
                                   @RequestParam BigDecimal amount) {
        return accountService.transferBetweenUsers(fromUserId, toUserId, amount);
    }
}
