package com.pulsbank.account.repository;

import com.pulsbank.account.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Репозиторий для работы с таблицей accounts.
 */
@Repository
public interface AccountRepository extends JpaRepository<Account, Long> {

    /**
     * Найти счёт по userId.
     */
    Optional<Account> findByUserId(Long userId);
}
