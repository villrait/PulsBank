package com.pulsbank.transfer.service.impl;

import com.pulsbank.transfer.client.AccountClient;
import com.pulsbank.transfer.dto.TransferResponse;
import com.pulsbank.transfer.dto.TransferResult;
import com.pulsbank.transfer.model.Transaction;
import com.pulsbank.transfer.repository.TransactionRepository;
import com.pulsbank.transfer.service.TransferService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Реальная реализация TransferService.
 * Транзакции сохраняются в БД, а деньги реально переводятся через account-service.
 */
@Service
@Transactional
public class TransferServiceImpl implements TransferService {

    private final TransactionRepository transactionRepository;
    private final AccountClient accountClient;

    public TransferServiceImpl(TransactionRepository transactionRepository, AccountClient accountClient) {
        this.transactionRepository = transactionRepository;
        this.accountClient = accountClient;
    }

    @Override
    public TransferResponse transfer(Long fromUserId, Long toUserId, BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return new TransferResponse(false, "invalid amount", null);
        }

        // Реально переводим деньги через account-service
        TransferResult result = accountClient.transfer(fromUserId, toUserId, amount);

        if (!result.isSuccess()) {
            return new TransferResponse(false, result.getMessage(), null);
        }

        // Сохраняем транзакцию в БД (журнал операций)
        Transaction tx = new Transaction();
        tx.setFromUserId(fromUserId);
        tx.setToUserId(toUserId);
        tx.setAmount(amount);
        tx.setTimestamp(LocalDateTime.now());
        transactionRepository.save(tx);

        return new TransferResponse(true, "ok", result.getNewBalance());
    }
}
