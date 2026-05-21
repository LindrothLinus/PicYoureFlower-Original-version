package com.pvt.auth;

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
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

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

    @Value("${user-service.url}")
    private String userServiceUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    @PostMapping("/google")
    public ResponseEntity<?> googleLogin(@RequestBody Map<String, String> body) {
        try {
            String idToken = body.get("idToken");

            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(), GsonFactory.getDefaultInstance())
                    .setAudience(Collections.singletonList(googleClientId))
                    .build();

            GoogleIdToken googleIdToken = verifier.verify(idToken);
            if (googleIdToken == null) return ResponseEntity.status(401).body("Ogiltigt token");

            GoogleIdToken.Payload payload = googleIdToken.getPayload();
            String googleId = payload.getSubject();
            String email = payload.getEmail();
            String name = (String) payload.get("name");

            Map<String, Object> user = findOrCreateUser(googleId, email, name);

            Long userId = ((Number) user.get("id")).longValue();
            String userName = (String) user.get("name");
            String userEmail = (String) user.get("email");

            String jwt = Jwts.builder()
                    .setSubject(String.valueOf(userId))
                    .claim("email", userEmail)
                    .claim("name", userName)
                    .setIssuedAt(new Date())
                    .setExpiration(new Date(System.currentTimeMillis() + 86400000))
                    .signWith(Keys.hmacShaKeyFor(jwtSecret.getBytes()), SignatureAlgorithm.HS256)
                    .compact();

            return ResponseEntity.ok(Map.of("token", jwt, "name", userName, "userId", userId));
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Fel: " + e.getMessage());
        }
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> findOrCreateUser(String googleId, String email, String name) {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(
                    userServiceUrl + "/users/by-google/" + googleId, Map.class);
            return response.getBody();
        } catch (HttpClientErrorException.NotFound e) {
            Map<String, String> newUser = Map.of("googleId", googleId, "email", email, "name", name);
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    userServiceUrl + "/users", newUser, Map.class);
            return response.getBody();
        }
    }
}