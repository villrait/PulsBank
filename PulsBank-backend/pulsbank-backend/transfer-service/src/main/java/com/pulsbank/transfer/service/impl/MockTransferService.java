package com.pulsbank.transfer.service.impl;

import com.pulsbank.transfer.dto.TransferResponse;
import com.pulsbank.transfer.model.Transaction;
import com.pulsbank.transfer.service.TransferService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

/**
 * In-memory реализация TransferService (без БД).
 *
 * <p>ВАЖНО: изоляция модулей — transfer-service не знает о классах account-service.
 * Поэтому в мок-режиме сервис держит собственные тестовые балансы.
 * TODO: в реальной реализации списание/зачисление будет идти через AccountClient
 * (HTTP-запросы к account-service), а транзакции храниться в БД.</p>
 */
@Service
public class MockTransferService implements TransferService {

    private static final BigDecimal INITIAL_BALANCE = new BigDecimal("1000.00");

    private final Map<Long, BigDecimal> balancesByUserId = new HashMap<>();
    private final AtomicLong idSequence = new AtomicLong(1);
    private final List<Transaction> transactions = new ArrayList<>();

    @Override
    public TransferResponse transfer(Long fromUserId, Long toUserId, BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return new TransferResponse(false, "invalid amount", null);
        }

        BigDecimal fromBalance = getOrCreateBalance(fromUserId);
        BigDecimal toBalance = getOrCreateBalance(toUserId);

        if (fromBalance.compareTo(amount) < 0) {
            return new TransferResponse(false, "insufficient funds", fromBalance);
        }

        BigDecimal newFromBalance = fromBalance.subtract(amount);
        BigDecimal newToBalance = toBalance.add(amount);
        balancesByUserId.put(fromUserId, newFromBalance);
        balancesByUserId.put(toUserId, newToBalance);

        Transaction tx = new Transaction(
                idSequence.getAndIncrement(),
                fromUserId,
                toUserId,
                amount,
                LocalDateTime.now()
        );
        transactions.add(tx);

        return new TransferResponse(true, "ok", newFromBalance);
    }

    private BigDecimal getOrCreateBalance(Long userId) {
        return balancesByUserId.computeIfAbsent(userId, id -> INITIAL_BALANCE);
    }
}