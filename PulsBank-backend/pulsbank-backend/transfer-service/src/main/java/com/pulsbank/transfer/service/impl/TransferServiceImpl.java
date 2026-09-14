package com.pulsbank.transfer.service.impl;

import com.pulsbank.transfer.dto.TransferResponse;
import com.pulsbank.transfer.model.Transaction;
import com.pulsbank.transfer.repository.TransactionRepository;
import com.pulsbank.transfer.service.TransferService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Реальная реализация TransferService: транзакции сохраняются в БД.
 *
 * ВАЖНО: балансы пока в памяти (мок), потому что HTTP-связей с account-service ещё нет.
 * Позже (Вариант B) заменим мок-балансы на HTTP-вызовы к account-service.
 */
@Service
@Transactional
public class TransferServiceImpl implements TransferService {

    private static final BigDecimal INITIAL_BALANCE = new BigDecimal("1000.00");

    private final TransactionRepository transactionRepository;

    // Временный мок-баланс (позже заменим на HTTP-вызовы к account-service)
    private final Map<Long, BigDecimal> balancesByUserId = new HashMap<>();

    public TransferServiceImpl(TransactionRepository transactionRepository) {
        this.transactionRepository = transactionRepository;
    }

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

        // Сохраняем транзакцию в БД
        Transaction tx = new Transaction();
        tx.setFromUserId(fromUserId);
        tx.setToUserId(toUserId);
        tx.setAmount(amount);
        tx.setTimestamp(LocalDateTime.now());
        transactionRepository.save(tx);

        return new TransferResponse(true, "ok", newFromBalance);
    }

    private BigDecimal getOrCreateBalance(Long userId) {
        return balancesByUserId.computeIfAbsent(userId, id -> INITIAL_BALANCE);
    }
}
