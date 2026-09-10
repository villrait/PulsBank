package com.pulsbank.transfer.service.impl;

import com.pulsbank.account.model.Account;
import com.pulsbank.account.service.impl.MockAccountService;
import com.pulsbank.transfer.dto.TransferResponse;
import com.pulsbank.transfer.model.Transaction;
import com.pulsbank.transfer.service.TransferService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

/**
 * In-memory реализация TransferService (без БД).
 *
 * <p>Важно: коллекции/операции не потокобезопасны; для MVP и локального запуска этого достаточно.</p>
 */
@Service
public class MockTransferService implements TransferService {
    private final MockAccountService accountService;
    private final AtomicLong idSequence = new AtomicLong(1);
    private final List<Transaction> transactions = new ArrayList<>();

    public MockTransferService(MockAccountService accountService) {
        this.accountService = accountService;
    }

    @Override
    public TransferResponse transfer(Long fromUserId, Long toUserId, BigDecimal amount) {
        // Минимальная защита от некорректных входных данных (без полноценной валидации).
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return new TransferResponse(false, "invalid amount", null);
        }

        // Для удобства в мок-режиме аккаунты создаются "на лету".
        Account from = accountService.getOrCreateAccount(fromUserId);
        Account to = accountService.getOrCreateAccount(toUserId);

        if (from.getBalance().compareTo(amount) < 0) {
            return new TransferResponse(false, "insufficient funds", from.getBalance());
        }

        // Пересчитываем новые балансы и записываем их обратно.
        BigDecimal newFromBalance = from.getBalance().subtract(amount);
        BigDecimal newToBalance = to.getBalance().add(amount);

        accountService.setBalance(fromUserId, newFromBalance);
        accountService.setBalance(toUserId, newToBalance);

        // Фиксируем факт перевода в памяти (вместо таблицы транзакций).
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
}

