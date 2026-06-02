package com.pvt.auth;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {"google.client-id=test-client-id", "jwt.secret=testsecrettestsecrettestsecrettestsecret123", "user-service.url=http://localhost:676767"})
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void googleLogin_emptyBody_returnsError() throws Exception {
        mockMvc.perform(post("/api/auth/google").contentType(MediaType.APPLICATION_JSON).content("{}")).andExpect(status().is5xxServerError());
    }

    @Test
    void googleLogin_invalidToken_returnsError() throws Exception {
        mockMvc.perform(post("/api/auth/google").contentType(MediaType.APPLICATION_JSON).content("{\"idToken\":\"not-a-real-token\"}")).andExpect(status().is5xxServerError());
    }

    @Test
    void googleLogin_missingContentType_returnsError() throws Exception {
        mockMvc.perform(post("/api/auth/google").content("{\"idToken\":\"test\"}")).andExpect(status().is4xxClientError());
    }

    @Test
    void googleLogin_nullToken_returnsError() throws Exception {
        mockMvc.perform(post("/api/auth/google").contentType(MediaType.APPLICATION_JSON).content("{\"idToken\":null}")).andExpect(status().is5xxServerError());
    }

    @Test
    void googleLogin_wrongField_returnsError() throws Exception {
        mockMvc.perform(post("/api/auth/google").contentType(MediaType.APPLICATION_JSON).content("{\"token\":\"some-value\"}")).andExpect(status().is5xxServerError());
    }
}