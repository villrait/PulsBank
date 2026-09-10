package com.pulsbank.auth.service.impl;

import com.pulsbank.account.service.AccountService;
import com.pulsbank.auth.model.User;
import com.pulsbank.auth.service.UserService;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

/**
 * In-memory реализация UserService (без БД).
 */
@Service
public class MockUserService implements UserService {
    // Две карты нужны для быстрых lookup'ов по разным ключам (id/email) без БД и индексов.
    private final Map<Long, User> usersById = new HashMap<>();
    private final Map<String, User> usersByEmail = new HashMap<>();
    private final AtomicLong idSequence = new AtomicLong(1);
    private final AccountService accountService;

    public MockUserService(AccountService accountService) {
        this.accountService = accountService;
    }

    @Override
    public User findByEmail(String email) {
        return usersByEmail.get(email);
    }

    @Override
    public User save(User user) {
        if (user.getId() == null) {
            user.setId(idSequence.getAndIncrement());
        }

        // В мок-режиме считаем email уникальным и просто перезаписываем индекс (без конфликтов/проверок).
        usersById.put(user.getId(), user);
        usersByEmail.put(user.getEmail(), user);

        // Упрощение для MVP: регистрируя пользователя, сразу создаём ему счёт с начальным балансом.
        accountService.createAccountForUser(user.getId());

        return user;
    }
}

