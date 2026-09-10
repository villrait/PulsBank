package com.pulsbank.account.service;

import java.math.BigDecimal;

/**
 * Сервис работы со счетами.
 */
public interface AccountService {

    /**
     * Возвращает баланс пользователя.
     *
     * @param userId id пользователя
     * @return баланс
     */
    BigDecimal getBalance(Long userId);

    /**
     * Создаёт счёт пользователю с балансом 1000.00, если его ещё нет.
     *
     * @param userId id пользователя
     */
    void createAccountForUser(Long userId);
}
