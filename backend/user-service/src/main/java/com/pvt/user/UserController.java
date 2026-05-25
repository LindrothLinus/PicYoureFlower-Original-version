package com.pvt.user;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin(origins = "*")
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/users/by-google/{googleId}")
    public ResponseEntity<User> findByGoogleId(@PathVariable String googleId) {
        return userRepository.findByGoogleId(googleId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/users")
    public ResponseEntity<User> createUser(@RequestBody Map<String, String> body) {
        User u = new User();
        u.setGoogleId(body.get("googleId"));
        u.setEmail(body.get("email"));
        u.setName(body.get("name"));
        return ResponseEntity.ok(userRepository.save(u));
    }

    @GetMapping("/users/{id}")
    public ResponseEntity<User> getUser(@PathVariable Long id) {
        return userRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/home/hello")
    public String hello() {
        return "hello";
    }

    @GetMapping("/home/allusers")
    public Iterable<User> getAllUsers() {
        return userRepository.findAll();
    }

    @GetMapping("/home/adduser")
    public Object addUser() {
        User entity = new User();
        return userRepository.save(entity);
    }

    @GetMapping("/home/friends/{userId}")
    public Object getAllFriends(@PathVariable Long userId) {
        User entity = userRepository.findById(userId)
                .orElseThrow(IllegalArgumentException::new);
        return entity.getFriends();
    }

    @PostMapping("/home/addfriend/{userId}/{friendId}")
    public String addFriends(@PathVariable Long userId, @PathVariable Long friendId) {
        User entity = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        User friend = userRepository.findById(friendId).orElseThrow(IllegalArgumentException::new);
        entity.getFriends().add(friend);
        friend.getFriends().add(entity);
        userRepository.save(friend);
        userRepository.save(entity);
        return "friend added";
    }

    @DeleteMapping("/home/removefriend/{userId}/{friendId}")
    public String removeFriends(@PathVariable Long userId, @PathVariable Long friendId) {
        User entity = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        User friend = userRepository.findById(friendId).orElseThrow(IllegalArgumentException::new);
        if (entity.getFriends().contains(friend)) {
            entity.getFriends().remove(friend);
            friend.getFriends().remove(entity);
        }
        userRepository.save(friend);
        userRepository.save(entity);
        return "friend removed";
    }

    @PutMapping("/home/setcoins/{userId}/{amount}")
    public Object setCoins(@PathVariable Long userId, @PathVariable int amount) {
        User entity = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        entity.setCoins(amount);
        return userRepository.save(entity);
    }

    @GetMapping("/home/coins/{userId}")
    public Object getCoins(@PathVariable Long userId) {
        User entity = userRepository.findById(userId)
                .orElseThrow(IllegalArgumentException::new);
        return entity.getCoins();
    }

    @GetMapping("/home/addcoins/{userId}/{amount}")
    public Object addCoins(@PathVariable Long userId, @PathVariable int amount) {
        User entity = userRepository.findById(userId)
                .orElseThrow(IllegalArgumentException::new);
        entity.setCoins(entity.getCoins() + amount);
        userRepository.save(entity);
        return entity.getCoins();
    }

    @GetMapping("/home/userpots/{userId}")
    public Iterable<PotTemplate> getUserPots(@PathVariable Long userId) {
        User entity = userRepository.findById(userId)
                .orElseThrow(IllegalArgumentException::new);
        return entity.getPots();
    }

    @PutMapping("/home/addpot/{userId}/{pot}")
    public Object addPots(@PathVariable Long userId, @PathVariable PotTemplate pot) {
        User entity = userRepository.findById(userId)
                .orElseThrow(IllegalArgumentException::new);
        entity.getPots().add(pot);
        return userRepository.save(entity);
    }

    @GetMapping("/home/allpots")
    public List<PotTemplate> getAllPots() {
        return List.of(PotTemplate.values());
    }
}
