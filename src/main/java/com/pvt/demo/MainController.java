package com.pvt.demo;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(path="/temp")
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

}