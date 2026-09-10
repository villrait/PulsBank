package com.pulsbank.auth.service;

import com.pulsbank.auth.model.User;

/**
 * Сервис работы с пользователями.
 */
public interface UserService {

    /**
     * Ищет пользователя по email.
     *
     * @param email email
     * @return пользователь или null
     */
    User findByEmail(String email);

    /**
     * Сохраняет пользователя (при необходимости присваивает id).
     *
     * @param user пользователь
     * @return сохранённый пользователь
     */
    User save(User user);
}

