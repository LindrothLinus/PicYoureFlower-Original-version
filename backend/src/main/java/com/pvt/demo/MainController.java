package com.pvt.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.reactive.function.client.WebClient;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
@RequestMapping(path="/home")
@CrossOrigin
public class MainController {

    @Autowired
    private EntityRepository entityRepository;

    private String[] types = {"Human", "Fish", "Alien", "Insect"};

    @GetMapping(path="/hello")
    public @ResponseBody String hello() {
        return "Hello Worlds!";
    }

    @GetMapping(path="/all")
    public @ResponseBody Iterable<DatabaseEntity> getAllEntities() {

        for(DatabaseEntity entity : entityRepository.findAll()) {
            int strikes = 0;
            if (entity.getLastFeed() != null && entity.getIntervalFeed() != null && entity.getLastFeed().plusHours(entity.getIntervalFeed()).isBefore(java.time.LocalDateTime.now())) {
                strikes++;
            }
            if (entity.getLastPlay() != null && entity.getIntervalPlay() != null && entity.getLastPlay().plusHours(entity.getIntervalPlay()).isBefore(java.time.LocalDateTime.now())) {
                strikes++;
            }
            if (entity.getLastTalk() != null && entity.getIntervalTalk() != null && entity.getLastTalk().plusHours(entity.getIntervalTalk()).isBefore(java.time.LocalDateTime.now())) {
                strikes++;
            }
            if (strikes > 2) {
                entityRepository.delete(entity);
            }
        }

        return entityRepository.findAll();
    }
    
    @GetMapping(path="/add/{name}/{type}")
    public @ResponseBody Object addEntity(@PathVariable String name, @PathVariable String type) {
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
            entity.setIntervalFeed((int)(Math.random() * 24) + 1);
            entity.setIntervalPlay((int)(Math.random() * 24) + 1);
            entity.setIntervalTalk((int)(Math.random() * 24) + 1);
            return entityRepository.save(entity);
        } catch (Exception e) {
            return "Failed to fetch entity data";
        }
    }

}