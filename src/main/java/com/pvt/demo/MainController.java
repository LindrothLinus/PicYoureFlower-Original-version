package com.pvt.demo;

@Controller
@RequestMapping(path="/temp")
@CrossOrigin
public class MainController {

    @GetMapping(value="/hello")
    public @ResponseBody String hello() {
        return "Hello!";
    }

}