package com.pulsbank.auth.service.impl;

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

    private final Map<Long, User> usersById = new HashMap<>();
    private final Map<String, User> usersByEmail = new HashMap<>();
    private final AtomicLong idSequence = new AtomicLong(1);

    @Override
    public User findByEmail(String email) {
        return usersByEmail.get(email);
    }

    @Override
    public User save(User user) {
        if (user.getId() == null) {
            user.setId(idSequence.getAndIncrement());
        }
        usersById.put(user.getId(), user);
        usersByEmail.put(user.getEmail(), user);
        return user;
    }
}