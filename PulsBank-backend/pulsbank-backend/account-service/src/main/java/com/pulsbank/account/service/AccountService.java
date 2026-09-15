package com.pulsbank.account.service;

import com.pulsbank.account.dto.TransferResult;

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
     * Создаёт счёт пользователю с начальным балансом, если его ещё нет.
     *
     * @param userId id пользователя
     */
    void createAccountForUser(Long userId);

    /**
     * Атомарно переводит сумму со счёта одного пользователя на счёт другого.
     *
     * @param fromUserId отправитель
     * @param toUserId получатель
     * @param amount сумма
     * @return результат операции
     */
    TransferResult transferBetweenUsers(Long fromUserId, Long toUserId, BigDecimal amount);
}
