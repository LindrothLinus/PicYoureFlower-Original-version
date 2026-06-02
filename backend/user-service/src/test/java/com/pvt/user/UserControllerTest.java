package com.pvt.user;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.StreamSupport;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@ExtendWith(MockitoExtension.class)
class UserControllerTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserController userController;

    private User sampleUser;

    @BeforeEach
    void setUp() {
        sampleUser = new User();
        sampleUser.setGoogleId("google-123");
        sampleUser.setEmail("test@example.com");
        sampleUser.setName("Test User");
        sampleUser.setCoins(0);
    }

    @Test
    void findByGoogleId_userExists_returns200() {
        when(userRepository.findByGoogleId("google-123")).thenReturn(Optional.of(sampleUser));

        ResponseEntity<User> response = userController.findByGoogleId("google-123");

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("google-123", response.getBody().getGoogleId());
    }

    @Test
    void findByGoogleId_userNotFound_returns404() {
        when(userRepository.findByGoogleId("unknown")).thenReturn(Optional.empty());

        ResponseEntity<User> response = userController.findByGoogleId("unknown");

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void createUser_savesAllFields() {
        Map<String, String> body = Map.of("googleId", "gid", "email", "a@b.com", "name", "Alice");
        when(userRepository.save(any(User.class))).thenAnswer(i -> i.getArgument(0));

        ResponseEntity<User> response = userController.createUser(body);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("Alice", response.getBody().getName());
        assertEquals("a@b.com", response.getBody().getEmail());
        assertEquals("gid", response.getBody().getGoogleId());
    }

    @Test
    void createUser_callsSaveOnRepository() {
        Map<String, String> body = Map.of("googleId", "gid", "email", "a@b.com", "name", "Alice");
        when(userRepository.save(any(User.class))).thenReturn(sampleUser);

        userController.createUser(body);

        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    void getUser_found_returns200() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(sampleUser));

        ResponseEntity<User> response = userController.getUser(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void getUser_notFound_returns404() {
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        ResponseEntity<User> response = userController.getUser(99L);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void getAllUsers_returnsAllUsers() {
        List<User> users = List.of(new User(), new User(), new User());
        when(userRepository.findAll()).thenReturn(users);

        Iterable<User> result = userController.getAllUsers();

        long count = StreamSupport.stream(result.spliterator(), false).count();
        assertEquals(3, count);
    }

    @Test
    void getAllUsers_emptyDatabase_returnsEmptyList() {
        when(userRepository.findAll()).thenReturn(List.of());

        Iterable<User> result = userController.getAllUsers();

        assertFalse(result.iterator().hasNext());
    }

    @Test
    void getCoins_returnsCorrectAmount() {
        sampleUser.setCoins(42);
        when(userRepository.findById(1L)).thenReturn(Optional.of(sampleUser));

        Object result = userController.getCoins(1L);

        assertEquals(42, result);
    }

    @Test
    void getCoins_userNotFound_throwsException() {
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> userController.getCoins(99L));
    }

    @Test
    void addCoins_increasesCoinsCorrectly() {
        sampleUser.setCoins(10);
        when(userRepository.findById(1L)).thenReturn(Optional.of(sampleUser));
        when(userRepository.save(any(User.class))).thenAnswer(i -> i.getArgument(0));

        Object result = userController.addCoins(1L, 5);

        assertEquals(15, result);
    }

    @Test
    void addCoins_addsZero_coinsUnchanged() {
        sampleUser.setCoins(20);
        when(userRepository.findById(1L)).thenReturn(Optional.of(sampleUser));
        when(userRepository.save(any(User.class))).thenAnswer(i -> i.getArgument(0));

        Object result = userController.addCoins(1L, 0);

        assertEquals(20, result);
    }

    @Test
    void addCoins_userNotFound_throwsException() {
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> userController.addCoins(99L, 10));
    }
/*

    @Test
    void getAllPots_returnsAllPotTemplates() {
        List<PotTemplate> pots = userController.getAllPots();

        assertEquals(PotTemplate.values().length, pots.size());
    }

    @Test
    void getAllPots_containsBlueAndGreen() {
        List<PotTemplate> pots = userController.getAllPots();

        assertTrue(pots.contains(PotTemplate.BLUE));
        assertTrue(pots.contains(PotTemplate.GREEN));
    }

     
    @Test
    void getUserPots_returnsPotsForUser() {
        sampleUser.getPots().add(PotEntity.setTemplate("BLUE"));
        sampleUser.getPots().add(PotTemplate.PINK);
        when(userRepository.findById(1L)).thenReturn(Optional.of(sampleUser));

        Iterable<PotEntity> result = userController.getUserPots(1L);

        long count = StreamSupport.stream(result.spliterator(), false).count();
        assertEquals(2, count);
    }

    @Test
    void getUserPots_noPots_returnsEmpty() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(sampleUser));

        Iterable<PotTemplate> result = userController.getUserPots(1L);

        assertFalse(result.iterator().hasNext());
    }

    @Test
    void addPots_addsPotToUser() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(sampleUser));
        when(userRepository.save(any(User.class))).thenAnswer(i -> i.getArgument(0));

        Object result = userController.addPots(1L, PotTemplate.PURPLE);

        assertTrue(((User) result).getPots().contains(PotTemplate.PURPLE));
    }

    @Test
    void addPots_userNotFound_throwsException() {
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> userController.addPots(99L, PotTemplate.BLUE));
    }
    */
    

    @Test
    void getAllFriends_returnsFriendSet() {
        User friend1 = new User();
        User friend2 = new User();
        sampleUser.setFriends(Set.of(friend1, friend2));
        when(userRepository.findById(1L)).thenReturn(Optional.of(sampleUser));

        List<FriendDTO> result = userController.getAllFriends(1L);

        assertEquals(2, result.size());
    }

    @Test
    void getAllFriends_noFriends_returnsEmptySet() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(sampleUser));

        List<FriendDTO> result = userController.getAllFriends(1L);

        assertTrue(result.isEmpty());
    }

    @Test
    void getAllFriends_userNotFound_throwsException() {
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> userController.getAllFriends(99L));
    }

    @Test
    void addUser_savesNewEmptyUser() {
        when(userRepository.save(any(User.class))).thenReturn(sampleUser);

        Object result = userController.addUser();

        assertNotNull(result);
        verify(userRepository, times(1)).save(any(User.class));
    }
}