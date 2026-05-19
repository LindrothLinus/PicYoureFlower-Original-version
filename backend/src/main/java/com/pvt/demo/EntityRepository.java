package com.pvt.demo;

import org.springframework.data.repository.CrudRepository;
import java.util.List;

public interface EntityRepository extends CrudRepository<DatabaseEntity, Integer> {
    List<DatabaseEntity> findByUsername(String username);

}