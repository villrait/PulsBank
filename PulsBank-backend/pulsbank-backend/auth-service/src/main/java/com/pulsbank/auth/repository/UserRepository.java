package com.pulsbank.auth.repository;

import com.pulsbank.auth.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Репозиторий для работы с таблицей users.
 * Spring Data JPA сам создаёт реализацию этого интерфейса.
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * Найти пользователя по email.
     */
    Optional<User> findByEmail(String email);
}
