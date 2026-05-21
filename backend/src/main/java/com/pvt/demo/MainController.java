package com.pvt.demo;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import javax.imageio.ImageIO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@RestController
@RequestMapping("/home")
@CrossOrigin(origins = "*")
public class MainController {

    @Autowired
    private EntityRepository entityRepository;

    @Autowired
    private UserRepository userRepository;

    private final String PLANTNET_API_KEY = "2b106hcgFkGyy2wiJf9y0Huhwu";
    private final String PLANTNET_URL = "https://my-api.plantnet.org/v2/identify/all?api-key=";
    private final String WIKIDATA_URL = "https://query.wikidata.org/sparql";

    private final ObjectMapper mapper = new ObjectMapper();
    private final RestTemplate restTemplate = new RestTemplate();

    @GetMapping("/all")
    public Iterable<DatabaseEntity> getAllEntities() {
        return entityRepository.findAll();
    }

    @GetMapping("/hello")
    public String hello() {
        return "hello";
    }

    // User repository methods bellow-------------------------------

    @GetMapping("/friends/{userId}")
    public Object getAllFriends(@PathVariable Long userId) {
        User entity = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        return userRepository.save(entity);
    }

    @GetMapping("/allusers")
    public Iterable<User> getAllUsers() {
        return userRepository.findAll();
    }

    @GetMapping("/adduser")
    public Object addUser() {
        User entity = new User();
        return userRepository.save(entity);
    }

    @GetMapping("/coins/{userId}")
    public Object getCoins(@PathVariable Long userId) {
        User entity = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        return entity.getCoins();
    }

    @GetMapping("/addcoins/{userId}/{amount}")
    public Object addCoins(@PathVariable Long userId, @PathVariable int amount) {
        User entity = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        entity.setCoins(entity.getCoins() + amount);
        userRepository.save(entity);
        return entity.getCoins();
    }

    @GetMapping("/userpots/{userId}")
    public Iterable<PotTemplate> getUserPots(@PathVariable Long userId) {
        User entity = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        return entity.getPots();
    }

    @PutMapping("/addpot/{userId}/{pot}")
    public Object addPots(@PathVariable Long userId, @PathVariable PotTemplate pot) {
        User entity = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        entity.getPots().add(pot);
        return userRepository.save(entity);
    }

    @GetMapping("/allpots")
    public List<PotTemplate> getAllPots() {
        return List.of(PotTemplate.values());
    }

    // User repository methods above-------------------------------

    @GetMapping("/user/{userId}/flowers")
    public Iterable<DatabaseEntity> getFlowersByUser(@PathVariable Long userId) {
        return entityRepository.findByUserId(userId);
    }

    @PutMapping("/addfloweruser/{flowerId}/{userId}")
    public Object addUserToFlower(@PathVariable Long flowerId, @PathVariable Long userId) {
        try {
            DatabaseEntity entity = entityRepository.findById(flowerId).orElseThrow(IllegalArgumentException::new);
            User user = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
            entity.setUser(user);
            return entityRepository.save(entity);
        } catch (IllegalArgumentException e) {
            return "Entity not found";
        }
    }

    @PostMapping("/add")
    public Object addEntity(@RequestBody @NonNull DatabaseEntity entity) {
        try {
            return entityRepository.save(entity);
        } catch (Exception e) {
            return "Error adding flower: " + e.getMessage();
        }
    }

    @PostMapping(value = "/identify", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> identifyAndSave(@RequestParam("image") MultipartFile image,
            @RequestParam(value = "userId", required = false) Long userId) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("images", image.getResource());
            body.add("organs", "flower");

            String plantNetJson = restTemplate.postForObject(PLANTNET_URL + PLANTNET_API_KEY,
                    new HttpEntity<>(body, headers), String.class);

            JsonNode rootNode = mapper.readTree(plantNetJson);
            JsonNode results = rootNode.path("results");

            List<String> scientificNames = new ArrayList<>();
            List<String> commonNames = new ArrayList<>();
            for (JsonNode r : results) {
                JsonNode species = r.path("species");
                String sci = species.path("scientificNameWithoutAuthor").asText(null);
                if (sci != null)
                    scientificNames.add(sci);
                for (JsonNode cn : species.path("commonNames"))
                    commonNames.add(cn.asText());
            }
            List<String> topSci = scientificNames.subList(0, Math.min(3, scientificNames.size()));
            List<String> topCom = commonNames.subList(0, Math.min(3, commonNames.size()));

            String color = findColor(topSci, topCom);
            if (color == null)
                color = getColor(image);

            ObjectNode response = (ObjectNode) rootNode;
            response.put("color", color);

            DatabaseEntity entity = new DatabaseEntity();
            entity.setCommonName(topCom.isEmpty() ? "Unknown" : topCom.get(0));
            entity.setLatinName(topSci.isEmpty() ? "Unknown" : topSci.get(0));
            entity.setColor(color);
            entity.setPicTaken(java.time.LocalDateTime.now());
            FlowerTemplate[] templates = FlowerTemplate.values();
            entity.setTemplate(templates[(int) (Math.random() * templates.length)]);

            if (userId != null) {
                Optional<User> user = userRepository.findById(userId);
                user.ifPresent(entity::setUser);
            }

            entityRepository.save(entity);

            return ResponseEntity.ok(mapper.writeValueAsString(response));
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error: " + e.getMessage());
        }
    }

    @PostMapping(path = "/color", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public @ResponseBody String getColor(@RequestParam("image") MultipartFile file) {
        try {
            BufferedImage img = ImageIO.read(file.getInputStream());
            int r = 0, g = 0, b = 0;
            int count = 0;
            int startX = img.getWidth() / 4;
            int endX = img.getWidth() * 3 / 4;
            int startY = img.getHeight() / 4;
            int endY = img.getHeight() * 3 / 4;
            for (int x = startX; x < endX; x++) {
                for (int y = startY; y < endY; y++) {
                    int pixel = img.getRGB(x, y);
                    int red = (pixel >> 16) & 0xff;
                    int green = (pixel >> 8) & 0xff;
                    int blue = pixel & 0xff;
                    if (green > red && green > blue)
                        continue;
                    r += red;
                    g += green;
                    b += blue;
                    count++;
                }
            }
            if (count == 0)
                return "#cccccc";
            return boostColor(r / count, g / count, b / count);
        } catch (Exception e) {
            return "#cccccc";
        }
    }

    private String boostColor(int r, int g, int b) {
        float[] hsb = Color.RGBtoHSB(r, g, b, null);
        float saturation = Math.min(1.0f, hsb[1] * 1.5f);
        float brightness = Math.min(1.0f, hsb[2] * 1.3f);
        int rgb = Color.HSBtoRGB(hsb[0], saturation, brightness);
        return String.format("#%02x%02x%02x", (rgb >> 16) & 0xff, (rgb >> 8) & 0xff, rgb & 0xff);
    }

    private String findColor(List<String> scientificNames, List<String> commonNames) {
        if (scientificNames.isEmpty())
            return null;

        StringBuilder unions = new StringBuilder();
        for (String name : scientificNames) {
            unions.append("{ ?plant wdt:P225 \"").append(escape(name)).append("\" . } UNION ");
        }
        for (String name : commonNames) {
            unions.append("{ ?plant rdfs:label \"").append(escape(name)).append("\"@en . } UNION ");
        }
        String genus = scientificNames.get(0).split(" ")[0];
        unions.append("{ ?plant wdt:P225 \"").append(escape(genus)).append("\" . }");

        String sparql = "SELECT ?hex WHERE { " +
                "{ " + unions + " } " +
                "?plant wdt:P2827 ?color . " +
                "?color wdt:P465 ?hex . " +
                "} LIMIT 1";

        return querySparql(sparql);
    }

    private String querySparql(String sparql) {
        for (int i = 0; i < 3; i++) {
            try {
                HttpHeaders h = new HttpHeaders();
                h.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
                h.set("Accept", "application/sparql-results+json");
                h.set("User-Agent", "PlantColorLookup/1.0");

                MultiValueMap<String, String> formBody = new LinkedMultiValueMap<>();
                formBody.add("query", sparql);

                ResponseEntity<String> resp = restTemplate.exchange(WIKIDATA_URL, HttpMethod.POST,
                        new HttpEntity<>(formBody, h), String.class);

                JsonNode bindings = mapper.readTree(resp.getBody()).path("results").path("bindings");
                if (bindings.isArray() && bindings.size() > 0) {
                    String val = bindings.get(0).path("hex").path("value").asText(null);
                    if (val != null && !val.isBlank())
                        return val.startsWith("#") ? val : "#" + val;
                }
                return null;
            } catch (Exception e) {
                System.out.println("SPARQL attempt " + (i + 1) + " failed: " + e.getMessage());
                if (i < 2)
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException ignored) {
                    }
            }
        }
        return null;
    }

    @GetMapping(path = "wikiinfo/{commonName}")
    public @ResponseBody Object getWikiInfo(@PathVariable String commonName) {
        try {
            final RestClient restClient = RestClient.create();
            String nameToSend = commonName; // add formatting here, remove spaces?
            String response = restClient.get().uri("https://en.wikipedia.org/api/rest_v1/page/summary/" + nameToSend)
                    .header("Accept", "application/json").retrieve().body(String.class);
            ObjectMapper mapper = new ObjectMapper();
            JsonNode json = mapper.readTree(response);
            return json.path("extract").asText();
        } catch (Exception e) {
            return "Could not find information";
        }
    }

    private String escape(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}