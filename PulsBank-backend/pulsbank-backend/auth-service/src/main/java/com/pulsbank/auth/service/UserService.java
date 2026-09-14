package com.pulsbank.auth.service;

import com.pulsbank.auth.model.User;

/**
 * Сервис работы с клиентами.
 */
public interface UserService {

    /**
     * Ищет клиента по номеру телефона.
     *
     * @param phone номер телефона
     * @return клиент или null
     */
    User findByPhone(String phone);

    /**
     * Сохраняет клиента (при необходимости присваивает id).
     *
     * @param user клиент
     * @return сохранённый клиент
     */
    User save(User user);
}
