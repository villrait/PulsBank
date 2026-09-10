package com.pulsbank.transfer.service;

import com.pulsbank.transfer.dto.TransferResponse;

import java.math.BigDecimal;

/**
 * Сервис переводов.
 */
public interface TransferService {

    /**
     * Переводит сумму от одного пользователя другому.
     *
     * @param fromUserId отправитель
     * @param toUserId получатель
     * @param amount сумма
     * @return результат перевода
     */
    TransferResponse transfer(Long fromUserId, Long toUserId, BigDecimal amount);
}
