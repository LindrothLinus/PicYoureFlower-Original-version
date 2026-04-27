package com.pvt.demo;

import org.springframework.data.repository.CrudRepository;

public interface EntityRepository extends CrudRepository<DatabaseEntity, Integer> {

}