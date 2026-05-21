package com.pvt.demo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface EntityRepository extends JpaRepository<DatabaseEntity, Long> {
    List<DatabaseEntity> findByUserId(long userId);
}