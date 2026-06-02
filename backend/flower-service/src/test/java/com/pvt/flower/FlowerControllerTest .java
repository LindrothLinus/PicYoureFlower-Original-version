package com.pvt.flower;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.StreamSupport;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class FlowerControllerTest {

    @Mock
    private EntityRepository entityRepository;

    @InjectMocks
    private FlowerController flowerController;

    private DatabaseEntity sampleEntity;

    @BeforeEach
    void setUp() {
        sampleEntity = new DatabaseEntity();
        sampleEntity.setCommonName("Rose");
        sampleEntity.setLatinName("Rosa canina");
        sampleEntity.setColor("#FF0000");
        sampleEntity.setTemplate(FlowerTemplate.ROSE);
        sampleEntity.setPicTaken(LocalDateTime.now());
        sampleEntity.setLocation("Uppsala, Sweden");
        sampleEntity.setUserId(1L);
    }

    @Test
    void getAllEntities_returnsAllFlowers() {
        List<DatabaseEntity> flowers = List.of(sampleEntity, new DatabaseEntity());
        when(entityRepository.findAll()).thenReturn(flowers);

        Iterable<DatabaseEntity> result = flowerController.getAllEntities();

        long count = StreamSupport.stream(result.spliterator(), false).count();
        assertEquals(2, count);
    }

    @Test
    void getAllEntities_emptyDatabase_returnsEmpty() {
        when(entityRepository.findAll()).thenReturn(List.of());

        Iterable<DatabaseEntity> result = flowerController.getAllEntities();

        assertFalse(result.iterator().hasNext());
    }

    @Test
    void getFlowersByUser_returnsFlowersForUser() {
        List<DatabaseEntity> flowers = List.of(sampleEntity, new DatabaseEntity());
        when(entityRepository.findByUserId(1L)).thenReturn(flowers);

        Iterable<DatabaseEntity> result = flowerController.getFlowersByUser(1L);

        long count = StreamSupport.stream(result.spliterator(), false).count();
        assertEquals(2, count);
    }

    @Test
    void getFlowersByUser_noFlowers_returnsEmpty() {
        when(entityRepository.findByUserId(99L)).thenReturn(List.of());

        Iterable<DatabaseEntity> result = flowerController.getFlowersByUser(99L);

        assertFalse(result.iterator().hasNext());
    }

    @Test
    void getFlowersByUser_onlyReturnsFlowersForCorrectUser() {
        when(entityRepository.findByUserId(1L)).thenReturn(List.of(sampleEntity));
        when(entityRepository.findByUserId(2L)).thenReturn(List.of());

        long user1Count = StreamSupport.stream(flowerController.getFlowersByUser(1L).spliterator(), false).count();
        long user2Count = StreamSupport.stream(flowerController.getFlowersByUser(2L).spliterator(), false).count();

        assertEquals(1, user1Count);
        assertEquals(0, user2Count);
    }

    @Test
    void deleteFlower_callsDeleteOnRepository() {
        when(entityRepository.findById(1L)).thenReturn(Optional.of(sampleEntity));

        flowerController.deleteFlower(1L);

        verify(entityRepository, times(1)).delete(sampleEntity);
    }

    @Test
    void deleteFlower_notFound_throwsException() {
        when(entityRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(IllegalArgumentException.class, () -> flowerController.deleteFlower(99L));
    }

    @Test
    void deleteFlower_notFound_doesNotCallDelete() {
        when(entityRepository.findById(99L)).thenReturn(Optional.empty());

        try {
            flowerController.deleteFlower(99L);
        } catch (IllegalArgumentException ignored) {}

        verify(entityRepository, never()).delete(any());
    }

    @Test
    void addUserToFlower_setsUserIdOnEntity() {
        sampleEntity.setUserId(null);
        when(entityRepository.findById(1L)).thenReturn(Optional.of(sampleEntity));
        when(entityRepository.save(any(DatabaseEntity.class))).thenAnswer(i -> i.getArgument(0));

        Object result = flowerController.addUserToFlower(1L, 5L);

        assertEquals(5L, ((DatabaseEntity) result).getUserId());
    }

    @Test
    void addUserToFlower_flowerNotFound_returnsErrorString() {
        when(entityRepository.findById(99L)).thenReturn(Optional.empty());

        Object result = flowerController.addUserToFlower(99L, 1L);

        assertEquals("Entity not found", result);
    }

    @Test
    void addUserToFlower_callsSaveOnRepository() {
        when(entityRepository.findById(1L)).thenReturn(Optional.of(sampleEntity));
        when(entityRepository.save(any(DatabaseEntity.class))).thenReturn(sampleEntity);

        flowerController.addUserToFlower(1L, 2L);

        verify(entityRepository, times(1)).save(any(DatabaseEntity.class));
    }

    @Test
    void addEntity_savesAndReturnsEntity() {
        when(entityRepository.save(sampleEntity)).thenReturn(sampleEntity);

        Object result = flowerController.addEntity(sampleEntity);

        assertEquals(sampleEntity, result);
    }

    @Test
    void addEntity_callsSaveOnRepository() {
        when(entityRepository.save(any(DatabaseEntity.class))).thenReturn(sampleEntity);

        flowerController.addEntity(sampleEntity);

        verify(entityRepository, times(1)).save(sampleEntity);
    }

    @Test
    void addEntity_saveThrows_returnsErrorString() {
        when(entityRepository.save(any())).thenThrow(new RuntimeException("DB error"));

        Object result = flowerController.addEntity(sampleEntity);

        assertTrue(result.toString().startsWith("Error adding flower:"));
    }

    @Test
    void databaseEntity_commonNameSetCorrectly() {
        assertEquals("Rose", sampleEntity.getCommonName());
    }

    @Test
    void databaseEntity_latinNameSetCorrectly() {
        assertEquals("Rosa canina", sampleEntity.getLatinName());
    }

    @Test
    void databaseEntity_colorSetCorrectly() {
        assertEquals("#FF0000", sampleEntity.getColor());
    }

    @Test
    void databaseEntity_templateSetCorrectly() {
        assertEquals(FlowerTemplate.ROSE, sampleEntity.getTemplate());
    }

    @Test
    void databaseEntity_locationSetCorrectly() {
        assertEquals("Uppsala, Sweden", sampleEntity.getLocation());
    }

    @Test
    void databaseEntity_userIdSetCorrectly() {
        assertEquals(1L, sampleEntity.getUserId());
    }

    @Test
    void databaseEntity_userIdCanBeNull() {
        DatabaseEntity entity = new DatabaseEntity();
        assertNull(entity.getUserId());
    }

    @Test
    void flowerTemplate_containsAllExpectedValues() {
        List<FlowerTemplate> templates = List.of(FlowerTemplate.values());

        assertTrue(templates.contains(FlowerTemplate.ROSE));
        assertTrue(templates.contains(FlowerTemplate.SUNFLOWER));
        assertTrue(templates.contains(FlowerTemplate.TULIP));
        assertTrue(templates.contains(FlowerTemplate.WOODANEMONE));
        assertTrue(templates.contains(FlowerTemplate.GENERIC));
    }

    @Test
    void flowerTemplate_hasFiveValues() {
        assertEquals(5, FlowerTemplate.values().length);
    }
}