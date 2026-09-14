package com.pulsbank.auth.service.impl;

import com.pulsbank.auth.model.User;
import com.pulsbank.auth.repository.UserRepository;
import com.pulsbank.auth.service.UserService;
import org.springframework.stereotype.Service;

/**
 * Реальная реализация UserService через БД (PostgreSQL).
 */
@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }

    @Override
    public User save(User user) {
        return userRepository.save(user);
    }
}
