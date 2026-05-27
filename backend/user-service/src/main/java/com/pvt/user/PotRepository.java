package com.pvt.user;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PotRepository extends JpaRepository<PotEntity, Long> {
    List<PotEntity> findByUser(User user);
    void deleteByUser(User user);
}