package com.pulsbank.auth.dto;

/**
 * Ответ аутентификации (регистрация/вход).
 */
public class AuthResponse {

    private Long userId;
    private String phone;
    private String message;

    public AuthResponse() {
    }

    public AuthResponse(Long userId, String phone, String message) {
        this.userId = userId;
        this.phone = phone;
        this.message = message;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
