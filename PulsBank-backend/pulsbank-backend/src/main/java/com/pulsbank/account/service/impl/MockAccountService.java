package com.pulsbank.account.service.impl;

import com.pulsbank.account.model.Account;
import com.pulsbank.account.service.AccountService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

/**
 * In-memory реализация AccountService (без БД).
 */
@Service
public class MockAccountService implements AccountService {
    // Строковая константа — чтобы избежать ошибок масштаба/округления при создании BigDecimal.
    private static final BigDecimal INITIAL_BALANCE = new BigDecimal("1000.00");

    // Ключ — userId (в MVP один пользователь = один счёт).
    private final Map<Long, Account> accountsByUserId = new HashMap<>();
    private final AtomicLong idSequence = new AtomicLong(1);

    @Override
    public BigDecimal getBalance(Long userId) {
        Account account = accountsByUserId.get(userId);
        if (account == null) {
            return BigDecimal.ZERO;
        }
        return account.getBalance();
    }

    @Override
    public void createAccountForUser(Long userId) {
        // Идемпотентно: повторный вызов не меняет существующий счёт и баланс.
        accountsByUserId.computeIfAbsent(userId, id -> new Account(idSequence.getAndIncrement(), id, INITIAL_BALANCE));
    }

    /**
     * Возвращает (или создаёт) счёт пользователя.
     *
     * <p>Метод живёт в impl, т.к. это деталь мок-хранилища, а не публичный контракт сервиса.</p>
     */
    public Account getOrCreateAccount(Long userId) {
        createAccountForUser(userId);
        return accountsByUserId.get(userId);
    }

    /**
     * Устанавливает новый баланс для пользователя.
     *
     * <p>В реальной реализации баланс будет меняться транзакционно в БД; здесь — просто запись в память.</p>
     */
    public void setBalance(Long userId, BigDecimal newBalance) {
        Account account = getOrCreateAccount(userId);
        account.setBalance(newBalance);
    }
}

