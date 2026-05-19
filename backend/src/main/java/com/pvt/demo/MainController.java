package com.pvt.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.MediaType;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;
import java.awt.Color;
import java.awt.image.BufferedImage;

import javax.imageio.ImageIO;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
@RequestMapping(path = "/home")
@CrossOrigin
public class MainController {

    private final DemoApplication demoApplication;
    @Autowired
    private EntityRepository entityRepository;

    MainController(DemoApplication demoApplication) {
        this.demoApplication = demoApplication;
    }

    @GetMapping(path = "/hello")
    public @ResponseBody String hello() {
        return "Hello!";
    }

    @GetMapping(path = "/all")
    public @ResponseBody Iterable<DatabaseEntity> getAllEntities() {

        return entityRepository.findAll();
    }

    @GetMapping(path = "/allbyuser/{username}")
    public @ResponseBody Iterable<DatabaseEntity> getAllEntitiesFromUser(@PathVariable String username) {

        return entityRepository.findByUsername(username);
    }

    @GetMapping(path = "/addusername/{id}/{username}")
    public @ResponseBody Object addUsername(@PathVariable @NonNull Integer id, @PathVariable String username) {
        try {
            DatabaseEntity entity = entityRepository.findById(id).orElseThrow(IllegalArgumentException::new);
            entity.setUsername(username);
            return entityRepository.save(entity);
        } catch (IllegalArgumentException e) {
            return "Entity not found";
        }
    }

    @PostMapping(path = "/identify", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public @ResponseBody Object identifyFlower(@RequestParam("image") MultipartFile file) {
        try {
            DatabaseEntity entity = new DatabaseEntity();

            // få ut namnet
            String names = getNameFromPic(file);
            String[] namesplit = names.split(" , ");
            FlowerTemplate template[] = FlowerTemplate.values();
            // sätta info
            entity.setCommonName(namesplit[0]);
            entity.setLatinName(namesplit[1]);
            entity.setColor(getColor(file));
            entity.setPicTaken(java.time.LocalDateTime.now());
            entity.setTemplate(template[(int) (Math.random() * template.length)]);
            // lägg till i databasen
            addEntity(entity);

            return entity;

        } catch (Exception e) {
            return "Entity not found";
        }

    }

    @PostMapping(path = "/add")
    public @ResponseBody Object addEntity(@RequestBody @NonNull DatabaseEntity entity) {
        try {

            return entityRepository.save(entity);

        } catch (Exception e) {
            return "Entity not found when trying to add flower";
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

                    // ignorera grönt
                    if (green > red && green > blue)
                        continue;

                    r += red;
                    g += green;
                    b += blue;

                    count++;

                }
            }
            if (count == 0)
                return "No color found";

            r /= count;
            g /= count;
            b /= count;
            String boostedColorAsHex = boostColor(r, g, b);

            return boostedColorAsHex;

        } catch (Exception e) {
            return "fail";
        }

    }

    private String boostColor(int r, int g, int b) {

        float[] hsb = Color.RGBtoHSB(r, g, b, null);

        float hue = hsb[0];
        float saturation = hsb[1];
        float brightness = hsb[2];

        saturation = Math.min(1.0f, saturation * 1.5f);

        brightness = Math.min(1.0f, brightness * 1.3f);

        int rgb = Color.HSBtoRGB(hue, saturation, brightness);

        int newR = (rgb >> 16) & 0xff;
        int newG = (rgb >> 8) & 0xff;
        int newB = rgb & 0xff;
        String hex = String.format("#%02x%02x%02x", newR, newG, newB);

        return hex;
    }

    @PostMapping(value = "/identifyflower", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public @ResponseBody String getNameFromPic(@RequestParam("image") MultipartFile image) throws Exception {
        final RestClient restClient = RestClient.create();
        final String PLANTNET_API_KEY = "2b10bQPZR3ms3av4jXItPft5H";
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("organs", "flower");
        body.add("images", new ByteArrayResource(image.getBytes()) {
            @Override
            public String getFilename() {
                return image.getOriginalFilename();
            }
        });

        String url = "https://my-api.plantnet.org/v2/identify/all?api-key=" + PLANTNET_API_KEY;
        String response = restClient.post().uri(url).contentType(MediaType.MULTIPART_FORM_DATA).body(body).retrieve()
                .body(String.class);

        ObjectMapper mapper = new ObjectMapper();
        JsonNode json = mapper.readTree(response);
        String bestMatch = json.path("bestMatch").asText();
        String commonName = json.path("results").get(0).path("species").path("commonNames").get(0).asText();
        return commonName + " , " + bestMatch; // Change this for other info
    }

    // updated version taking and sending more info
    @PostMapping(value = "/fromcamera", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public @ResponseBody Object getNameFromPic(@RequestParam("image") MultipartFile image,
            @RequestParam("owner") String owner) throws Exception {
        // identifierar
        final RestClient restClient = RestClient.create();
        final String PLANTNET_API_KEY = "2b10bQPZR3ms3av4jXItPft5H";
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("organs", "flower");
        body.add("images", new ByteArrayResource(image.getBytes()) {
            @Override
            public String getFilename() {
                return image.getOriginalFilename();
            }
        });
        String url = "https://my-api.plantnet.org/v2/identify/all?api-key=" + PLANTNET_API_KEY;
        String response = restClient.post().uri(url).contentType(MediaType.MULTIPART_FORM_DATA).body(body).retrieve()
                .body(String.class);

        ObjectMapper mapper = new ObjectMapper();
        JsonNode json = mapper.readTree(response);
        String bestMatch = json.path("bestMatch").asText();
        String commonName = json.path("results").get(0).path("species").path("commonNames").get(0).asText();
        FlowerTemplate template[] = FlowerTemplate.values();

        // skapa databasentry
        DatabaseEntity entity = new DatabaseEntity();
        entity.setCommonName(commonName);
        entity.setLatinName(bestMatch);
        entity.setColor(getColor(image)); // testa detta
        entity.setPicTaken(java.time.LocalDateTime.now());
        entity.setTemplate(template[(int) (Math.random() * template.length)]); // slumpmässig
        // entity.setOwner(owner); ta bort kommentar när setOwner är implementerat

        // lägg till i databasen
        addEntity(entity);

        return entity;

        // return commonName + " , " + bestMatch; // Change this for other info
    }

    @GetMapping(path = "wikiinfo/{commonName}")
    public @ResponseBody Object getWikiInfo(@PathVariable String commonName) {
        try {
            final RestClient restClient = RestClient.create();
            String nameToSend = commonName; // add formatting here, remove spaces?
            String response = restClient.get()
                    .uri("https://en.wikipedia.org/api/rest_v1/page/summary/" + nameToSend)
                    .header("Accept", "application/json")
                    .retrieve()
                    .body(String.class);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode json = mapper.readTree(response);
            return json.path("extract").asText();

        } catch (Exception e) {
            return "Could not find information";
        }
    }
}