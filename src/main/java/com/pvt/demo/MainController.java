package com.pvt.demo;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.http.MediaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.http.ResponseEntity;

@Controller
@RequestMapping(path="/home")
@CrossOrigin
public class MainController {

    @Autowired
    private EntityRepository entityRepository;

    @GetMapping(path="/hello")
    public @ResponseBody String hello() {
        return "Hello World!";
    }

    @GetMapping(path="/all")
    public @ResponseBody Iterable<DatabaseEntity> getAllEntities() {
        return entityRepository.findAll();
    }
    
    @GetMapping(path="/add/{name}/{type}")
    public @ResponseBody DatabaseEntity addEntity(@PathVariable String name, @PathVariable String type) {
        DatabaseEntity entity = new DatabaseEntity();
        entity.setName(name);
        entity.setType(type);
        return entityRepository.save(entity);
    }

    @GetMapping(path="/talk/{id}")
    public @ResponseBody Object entityTalk(@PathVariable Integer id) { //may return string and DatabaseEntity
        try {
            DatabaseEntity entity = entityRepository.findById(id).orElseThrow(IllegalArgumentException::new);
            entity.setLastTalk(java.time.LocalDateTime.now());
            return entityRepository.save(entity);
        } catch (IllegalArgumentException e) {
            return "Entity not found";
        }
    }

    @GetMapping(path="/feed/{id}")
    public @ResponseBody Object entityFeed(@PathVariable Integer id) {
        try {
            DatabaseEntity entity = entityRepository.findById(id).orElseThrow(IllegalArgumentException::new);
            entity.setLastFeed(java.time.LocalDateTime.now());
            return entityRepository.save(entity);
        } catch (IllegalArgumentException e) {
            return "Entity not found";
        }
    }

    @GetMapping(path="/play/{id}")
    public @ResponseBody Object entityPlay(@PathVariable Integer id) {
        try {
            DatabaseEntity entity = entityRepository.findById(id).orElseThrow(IllegalArgumentException::new);
            entity.setLastPlay(java.time.LocalDateTime.now());
            return entityRepository.save(entity);
        } catch (IllegalArgumentException e) {
            return "Entity not found";
        }
    }

    @GetMapping(path="/rename/{id}/{name}")
    public @ResponseBody Object entityRename(@PathVariable Integer id, @PathVariable String name) {
        try {
            DatabaseEntity entity = entityRepository.findById(id).orElseThrow(IllegalArgumentException::new);
            entity.setName(name);
            return entityRepository.save(entity);
        } catch (IllegalArgumentException e) {
            return "Entity not found";
        }
    }

    @GetMapping(path="/roll")
    public @ResponseBody Object rollNewEntity() {
        WebClient client = WebClient.create("https://api.namefake.com");
        
        try {
            String result = client.get().uri("/english-sweden").accept(MediaType.APPLICATION_JSON).retrieve().bodyToMono(String.class).block();
            ObjectMapper mapper = new ObjectMapper();
            JsonNode jsonNode = mapper.readTree(result);
            String name = jsonNode.get("name").asText();
            DatabaseEntity entity = new DatabaseEntity();
            entity.setName(name);
            entity.setType(types[(int)(Math.random() * types.length)]);
            return entityRepository.save(entity);
        } catch (Exception e) {
            return "Failed to fetch entity data";
        }
    }

    public String[] types = {"Human", "Fish", "Alien", "Insect"};

}