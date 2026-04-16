package com.pvt.demo;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.http.MediaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

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
    // 1. Hämta alla först och lägg i en lista
    List<DatabaseEntity> all = (List<DatabaseEntity>) entityRepository.findAll();
    List<DatabaseEntity> toDelete = new java.util.ArrayList<>();

    // 2. Identifiera vilka som ska bort
    for(DatabaseEntity entity : all) {
        int strikes = 0;
        java.time.LocalDateTime now = java.time.LocalDateTime.now();

        if (entity.getLastFeed() != null && entity.getLastFeed().plusHours(entity.getIntervalFeed()).isBefore(now)) strikes++;
        if (entity.getLastPlay() != null && entity.getLastPlay().plusHours(entity.getIntervalPlay()).isBefore(now)) strikes++;
        if (entity.getLastTalk() != null && entity.getLastTalk().plusHours(entity.getIntervalTalk()).isBefore(now)) strikes++;

        if (strikes > 2) {
            toDelete.add(entity); // Lägg till i listan istället för att radera direkt
        }
    }

    // 3. Radera alla markerade djur nu när loopen är klar
    if (!toDelete.isEmpty()) {
        entityRepository.deleteAll(toDelete);
        // Uppdatera vår lokala lista så vi inte returnerar döda djur
        all.removeAll(toDelete);
    }

    return all;
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

    public String[] types = {"Human", "Fish", "Alien", "Insect"};

}