package com.pulsbank.transfer.repository;

import com.pulsbank.transfer.model.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Репозиторий для работы с таблицей transactions.
 */
@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {

    /**
     * Найти все транзакции пользователя (как отправителя или получателя).
     */
    List<Transaction> findByFromUserIdOrToUserId(Long fromUserId, Long toUserId);
}
