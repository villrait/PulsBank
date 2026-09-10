package com.pulsbank.transfer.dto;

import java.math.BigDecimal;

/**
 * Ответ на перевод.
 */
public class TransferResponse {
    private boolean success;
    private String message;
    /**
     * Новый баланс отправителя (fromUserId) после перевода.
     */
    private BigDecimal newBalance;

    public TransferResponse() {
    }

    public TransferResponse(boolean success, String message, BigDecimal newBalance) {
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
