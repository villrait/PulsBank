package com.pulsbank.transfer.dto;

import java.math.BigDecimal;

/**
 * Результат операции перевода между счетами (ответ от account-service).
 */
public class TransferResult {

    private boolean success;
    private String message;
    private BigDecimal newBalance;

    public TransferResult() {
    }

    public TransferResult(boolean success, String message, BigDecimal newBalance) {
        this.success = success;
        this.message = message;
        this.newBalance = newBalance;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public BigDecimal getNewBalance() {
        return newBalance;
    }

    public void setNewBalance(BigDecimal newBalance) {
        this.newBalance = newBalance;
    }
}
