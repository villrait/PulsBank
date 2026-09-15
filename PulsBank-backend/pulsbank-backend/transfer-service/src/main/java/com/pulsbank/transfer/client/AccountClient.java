package com.pulsbank.transfer.client;

import com.pulsbank.transfer.dto.TransferResult;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;

/**
 * HTTP-клиент для вызовов account-service.
 * Используется для списания/зачисления денег при переводе.
 */
@Component
public class AccountClient {

    private static final String ACCOUNT_SERVICE_URL = "http://localhost:8082";

    private final RestTemplate restTemplate;

    public AccountClient(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    /**
     * Переводит сумму между счетами через account-service.
     *
     * @param fromUserId отправитель
     * @param toUserId получатель
     * @param amount сумма
     * @return результат перевода
     */
    public TransferResult transfer(Long fromUserId, Long toUserId, BigDecimal amount) {
        String url = ACCOUNT_SERVICE_URL + "/account/transfer?fromUserId=" + fromUserId
                + "&toUserId=" + toUserId + "&amount=" + amount;
        return restTemplate.postForObject(url, null, TransferResult.class);
    }
}
