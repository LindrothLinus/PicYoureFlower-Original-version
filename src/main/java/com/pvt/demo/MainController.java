package com.pvt.demo;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
@RequestMapping(path="/home")
@CrossOrigin
public class MainController {

    @Autowired
    private EntityRepository entityRepository;

    @GetMapping(value="/hello")
    public @ResponseBody String hello() {
        return "Hello World!";
    }

    @GetMapping(value="/all")
    public @ResponseBody Iterable<DatabaseEntity> getAllEntities() {
        return entityRepository.findAll();
    }
    
    @GetMapping(value="/add/{name}/{type}")
    public @ResponseBody DatabaseEntity addEntity(@PathVariable String name, @PathVariable String type) {
        DatabaseEntity entity = new DatabaseEntity();
        entity.setName(name);
        entity.setType(type);
        return entityRepository.save(entity);
    }

    @GetMapping(value="/talk/{id}")
    public @ResponseBody Object entityTalk(@PathVariable Integer id) { //may return string and DatabaseEntity
        try {
            DatabaseEntity entity = entityRepository.findById(id).orElseThrow(IllegalArgumentException::new);
            entity.setLastTalk(java.time.LocalDateTime.now());
            return entityRepository.save(entity);
        } catch (IllegalArgumentException e) {
            return "Entity not found";
        }
    }

    @GetMapping(value="/feed/{id}")
    public @ResponseBody Object entityFeed(@PathVariable Integer id) {
        try {
            DatabaseEntity entity = entityRepository.findById(id).orElseThrow(IllegalArgumentException::new);
            entity.setLastFeed(java.time.LocalDateTime.now());
            return entityRepository.save(entity);
        } catch (IllegalArgumentException e) {
            return "Entity not found";
        }
    }

    @GetMapping(value="/play/{id}")
    public @ResponseBody Object entityPlay(@PathVariable Integer id) {
        try {
            DatabaseEntity entity = entityRepository.findById(id).orElseThrow(IllegalArgumentException::new);
            entity.setLastPlay(java.time.LocalDateTime.now());
            return entityRepository.save(entity);
        } catch (IllegalArgumentException e) {
            return "Entity not found";
        }
    }

}