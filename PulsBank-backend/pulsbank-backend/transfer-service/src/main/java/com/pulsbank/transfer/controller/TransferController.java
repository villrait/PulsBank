package com.pulsbank.transfer.controller;

import com.pulsbank.transfer.dto.TransferRequest;
import com.pulsbank.transfer.dto.TransferResponse;
import com.pulsbank.transfer.service.TransferService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Эндпоинт перевода денег.
 */
@RestController
@RequestMapping("/transfer")
public class TransferController {
    private final TransferService transferService;

    public TransferController(TransferService transferService) {
        this.transferService = transferService;
    }

    /**
     * Выполняет перевод.
     */
    @PostMapping
    public TransferResponse transfer(@RequestBody TransferRequest request) {
        return transferService.transfer(request.getFromUserId(), request.getToUserId(), request.getAmount());
    }
}
