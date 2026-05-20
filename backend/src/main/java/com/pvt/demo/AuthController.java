package com.pvt.demo;

import java.util.Collections;
import java.util.Date;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Value("${google.client-id}")
    private String googleClientId;

    @Value("${jwt.secret}")
    private String jwtSecret;

    private final UserRepository userRepository;

    public AuthController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @PostMapping("/google")
    public ResponseEntity<?> googleLogin(@RequestBody Map<String, String> body) {
        try {
            String idToken = body.get("idToken");

            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), GsonFactory.getDefaultInstance()).setAudience(Collections.singletonList(googleClientId)).build();

            GoogleIdToken googleIdToken = verifier.verify(idToken);
            if (googleIdToken == null) return ResponseEntity.status(401).body("Ogiltigt token");

            GoogleIdToken.Payload payload = googleIdToken.getPayload();
            String googleId = payload.getSubject();
            String email = payload.getEmail();
            String name = (String) payload.get("name");

            User user = userRepository.findByGoogleId(googleId).orElseGet(() -> {
                User u = new User();
                u.setGoogleId(googleId);
                u.setEmail(email);
                u.setName(name);
                return userRepository.save(u);
            });

            String jwt = Jwts.builder().setSubject(String.valueOf(user.getId())).claim("email", user.getEmail()).claim("name", user.getName()).setIssuedAt(new Date()).setExpiration(new Date(System.currentTimeMillis() + 86400000)).signWith(Keys.hmacShaKeyFor(jwtSecret.getBytes()), SignatureAlgorithm.HS256).compact();

            return ResponseEntity.ok(Map.of("token", jwt, "name", user.getName(), "userId", user.getId()));
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Fel: " + e.getMessage());
        }
    }
}