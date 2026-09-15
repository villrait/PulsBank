package com.pulsbank.auth.client;

import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

/**
 * HTTP-клиент для вызовов account-service.
 * Используется для открытия счёта при регистрации клиента.
 */
@Component
public class AccountClient {

    private static final String ACCOUNT_SERVICE_URL = "http://localhost:8082";

    private final RestTemplate restTemplate;

    public AccountClient(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    /**
     * Открывает счёт для клиента через account-service.
     *
     * @param userId ID клиента
     */
    public void openAccount(Long userId) {
        String url = ACCOUNT_SERVICE_URL + "/account/open?userId=" + userId;
        restTemplate.postForObject(url, null, String.class);
    }
}
