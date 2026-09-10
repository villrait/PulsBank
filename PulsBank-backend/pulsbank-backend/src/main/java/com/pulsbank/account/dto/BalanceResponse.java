package com.pulsbank.account.dto;

import java.math.BigDecimal;

/**
 * Ответ на запрос баланса.
 */
public class BalanceResponse {
    private Long userId;
    private BigDecimal balance;

    public BalanceResponse() {
    }

    public BalanceResponse(Long userId, BigDecimal balance) {
        this.userId = userId;
        this.balance = balance;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }
}
