package com.pulsbank.account.service.impl;

import com.pulsbank.account.model.Account;
import com.pulsbank.account.repository.AccountRepository;
import com.pulsbank.account.service.AccountService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

/**
 * Реальная реализация AccountService через БД (PostgreSQL).
 */
@Service
@Transactional
public class AccountServiceImpl implements AccountService {

    private static final BigDecimal INITIAL_BALANCE = new BigDecimal("1000.00");

    private final AccountRepository accountRepository;

    public AccountServiceImpl(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    @Override
    public BigDecimal getBalance(Long userId) {
        return accountRepository.findByUserId(userId)
                .map(Account::getBalance)
                .orElse(BigDecimal.ZERO);
    }

    @Override
    public void createAccountForUser(Long userId) {
        // Идемпотентно: если счёт уже есть, ничего не делаем
        if (accountRepository.findByUserId(userId).isEmpty()) {
            Account account = new Account();
            account.setUserId(userId);
            account.setBalance(INITIAL_BALANCE);
            accountRepository.save(account);
        }
    }

    /**
     * Возвращает (или создаёт) счёт пользователя.
     * Используется внутренне для операций списания/зачисления.
     */
    public Account getOrCreateAccount(Long userId) {
        return accountRepository.findByUserId(userId)
                .orElseGet(() -> {
                    Account account = new Account();
                    account.setUserId(userId);
                    account.setBalance(INITIAL_BALANCE);
                    return accountRepository.save(account);
                });
    }

    /**
     * Устанавливает новый баланс для пользователя.
     */
    public void setBalance(Long userId, BigDecimal newBalance) {
        Account account = getOrCreateAccount(userId);
        account.setBalance(newBalance);
        accountRepository.save(account);
    }
}
