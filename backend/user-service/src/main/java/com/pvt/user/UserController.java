package com.pvt.user;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.lang.NonNull;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

//import jakarta.transaction.Transactional; ger error

@RestController
@CrossOrigin(origins = "*")
public class UserController {

    private final UserRepository userRepository;
    private final PotRepository potRepository;

    public UserController(UserRepository userRepository, PotRepository potRepository) {
        this.userRepository = userRepository;
        this.potRepository = potRepository;
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
        u.setProfilePicture("Avatar_Green");
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

    @PostMapping("/home/adduser")
    public Object addUser() {
        User entity = new User();
        return userRepository.save(entity);
    }

    @Transactional
    @DeleteMapping("/home/removeuser/{userId}")
    public Object removeUser(@PathVariable @NonNull Long userId) {
        User entity = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        List<User> users = userRepository.findAll();
        for (User user : users) {
            if (user.getFriends().contains(entity)) {
                removeFriends(userId, user.getId());
            }
        }

        entity.getPots().clear();
        entity.getFriends().clear();
        userRepository.deleteById(userId);
        return "Deleted!";
    }

    @GetMapping("/home/friends/{userId}")
    public List<FriendDTO> getAllFriends(@PathVariable @NonNull Long userId) {
        User entity = userRepository.findById(userId)
                .orElseThrow(IllegalArgumentException::new);
        return entity.getFriends().stream().map(friend -> new FriendDTO(
                friend.getId(),
                friend.getName(),
                friend.getProfilePicture() != null ? friend.getProfilePicture() : "Avatar_Green")).toList();
    }

    @PostMapping("/home/addfriend/{userId}/{friendId}")
    public String addFriends(@PathVariable @NonNull Long userId, @PathVariable @NonNull Long friendId) {
        User entity = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        User friend = userRepository.findById(friendId).orElseThrow(IllegalArgumentException::new);
        entity.getFriends().add(friend);
        friend.getFriends().add(entity);
        userRepository.save(friend);
        userRepository.save(entity);
        return "friend added";
    }

    @DeleteMapping("/home/removefriend/{userId}/{friendId}")
    public String removeFriends(@PathVariable @NonNull Long userId, @PathVariable @NonNull Long friendId) {
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
    public Iterable<PotEntity> getUserPots(@PathVariable Long userId) {
        User entity = userRepository.findById(userId)
                .orElseThrow(IllegalArgumentException::new);
        return entity.getPots();
    }

    @PutMapping("/home/addpot/{userId}/{template}")
    public ResponseEntity<?> addPots(@PathVariable Long userId, @PathVariable PotTemplate template) {
        User entity = userRepository.findById(userId)
                .orElseThrow(IllegalArgumentException::new);
        if (entity.getOwnedPotTemplates().contains(template)) {
            return ResponseEntity.status(409).body("Already owned");
        }
        entity.getOwnedPotTemplates().add(template);
        userRepository.save(entity);
        return ResponseEntity.ok(
            entity.getOwnedPotTemplates().stream()
                .map(PotTemplate::name)
                .collect(Collectors.toList())
        );
    }

    @GetMapping("/home/ownedpottemplates/{userId}")
    public ResponseEntity<List<String>> getOwnedPotTemplates(@PathVariable Long userId) {
        User entity = userRepository.findById(userId)
                .orElseThrow(IllegalArgumentException::new);
        return ResponseEntity.ok(
            entity.getOwnedPotTemplates().stream()
                .map(PotTemplate::name)
                .collect(Collectors.toList())
        );
    }

    @GetMapping("/home/allpots")
    public List<PotEntity> getAllPots() {
        return potRepository.findAll();
    }

    @PutMapping("/home/setpotplaced/{potId}/{trueorfalse}")
    public String setPotPlaced(@PathVariable long potId, @PathVariable int trueorfalse) {
        PotEntity pot = potRepository.findById(potId)
                .orElseThrow(IllegalArgumentException::new);
        if (trueorfalse == 0)
            pot.setPlaced(false);
        if (trueorfalse == 1)
            pot.setPlaced(true);
        return "placed";
    }

    @GetMapping("/home/greenhouse/{userId}")
    public List<PotEntity> getGreenhouse(@PathVariable Long userId) {
        User user = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        return potRepository.findByUser(user);
    }

    @PostMapping("/home/greenhouse/{userId}")
    @Transactional
    public ResponseEntity<?> saveGreenhouse(@PathVariable Long userId,
            @RequestBody List<Map<String, Object>> placements) {
        User user = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        potRepository.deleteByUser(user);
        for (Map<String, Object> p : placements) {
            PotEntity pot = new PotEntity();
            pot.setPlacementId(((Number) p.get("placementId")).intValue());
            Object templateObj = p.getOrDefault("potTemplate", "BLUE");
            pot.setTemplate(PotTemplate.valueOf(templateObj.toString()));
            pot.setUser(user);
            if (p.get("flowerId") != null) {
                pot.setFlowerId(((Number) p.get("flowerId")).longValue());
            }
            potRepository.save(pot);
        }
        return ResponseEntity.ok().build();
    }

    @GetMapping("/home/likes/{userId}")
    public int getLikes(@PathVariable Long userId) {
        User user = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);

        return user.getLikes();
    }

    @PutMapping("/home/addlikes/{userId}/{amount}")
    public String addLikes(@PathVariable @NonNull Long userId, @PathVariable int amount) {
        User user = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        user.setLikes(user.getLikes() + amount);
        userRepository.save(user);
        return "added like";
    }

    @PutMapping("/home/setprofilepicture/{userId}/{picture}")
    public ResponseEntity<?> setProfilePicture(@PathVariable Long userId, @PathVariable String picture) {
        User entity = userRepository.findById(userId).orElseThrow(IllegalArgumentException::new);
        entity.setProfilePicture(picture);
        userRepository.save(entity);
        return ResponseEntity.ok().build();
    }

}