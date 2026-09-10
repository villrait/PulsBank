package com.pulsbank.transfer.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Транзакция перевода между пользователями.
 */
public class Transaction {
    private Long id;
    private Long fromUserId;
    private Long toUserId;
    private BigDecimal amount;
    private LocalDateTime timestamp;

    public Transaction() {
    }

    public Transaction(Long id, Long fromUserId, Long toUserId, BigDecimal amount, LocalDateTime timestamp) {
        this.id = id;
        this.fromUserId = fromUserId;
        this.toUserId = toUserId;
        this.amount = amount;
        this.timestamp = timestamp;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getFromUserId() {
        return fromUserId;
    }

    public void setFromUserId(Long fromUserId) {
        this.fromUserId = fromUserId;
    }

    public Long getToUserId() {
        return toUserId;
    }

    public void setToUserId(Long toUserId) {
        this.toUserId = toUserId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
}
