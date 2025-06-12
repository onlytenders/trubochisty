package com.trubochisty.truboserver.service;

import com.trubochisty.truboserver.dto.request.CulvertRequest;
import com.trubochisty.truboserver.exception.ResourceNotFoundException;
import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.repository.CulvertRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CulvertServiceTest {

    @Mock
    private CulvertRepository culvertRepository;

    @InjectMocks
    private CulvertService culvertService;

    private Culvert testCulvert;
    private CulvertRequest testRequest;

    @BeforeEach
    void setUp() {
        testCulvert = Culvert.builder()
                .id("test-id-1")
                .address("Test Address 1")
                .coordinates("55.7558,37.6173")
                .road("Test Road 1")
                .serialNumber("TEST-001")
                .pipeType("Round")
                .material("Concrete")
                .diameter("1.5")
                .length("12.0")
                .headType("Standard")
                .foundationType("Concrete")
                .workType("New Construction")
                .constructionYear("2020")
                .strengthRating(4.5)
                .safetyRating(4.0)
                .maintainabilityRating(4.2)
                .generalConditionRating(4.3)
                .build();

        testRequest = new CulvertRequest();
        testRequest.setAddress("Test Address 1");
        testRequest.setCoordinates("55.7558,37.6173");
        testRequest.setRoad("Test Road 1");
        testRequest.setSerialNumber("TEST-001");
        testRequest.setPipeType("Round");
        testRequest.setMaterial("Concrete");
        testRequest.setDiameter("1.5");
        testRequest.setLength("12.0");
        testRequest.setHeadType("Standard");
        testRequest.setFoundationType("Concrete");
        testRequest.setWorkType("New Construction");
        testRequest.setConstructionYear("2020");
        testRequest.setStrengthRating(4.5);
        testRequest.setSafetyRating(4.0);
        testRequest.setMaintainabilityRating(4.2);
        testRequest.setGeneralConditionRating(4.3);
    }

    @Test
    void getAllCulverts_ShouldReturnAllCulverts() {
        when(culvertRepository.findAll()).thenReturn(Arrays.asList(testCulvert));

        List<Culvert> result = culvertService.getAllCulverts();

        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(testCulvert, result.get(0));
        verify(culvertRepository).findAll();
    }

    @Test
    void getCulvertById_WhenCulvertExists_ShouldReturnCulvert() {
        when(culvertRepository.findById("test-id-1")).thenReturn(Optional.of(testCulvert));

        Culvert result = culvertService.getCulvertById("test-id-1");

        assertNotNull(result);
        assertEquals(testCulvert, result);
        verify(culvertRepository).findById("test-id-1");
    }

    @Test
    void getCulvertById_WhenCulvertDoesNotExist_ShouldThrowException() {
        when(culvertRepository.findById("non-existent")).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class, () -> culvertService.getCulvertById("non-existent"));
        verify(culvertRepository).findById("non-existent");
    }

    @Test
    void createCulvert_WhenSerialNumberIsUnique_ShouldCreateCulvert() {
        when(culvertRepository.findBySerialNumberContainingIgnoreCase(any())).thenReturn(List.of());
        when(culvertRepository.save(any())).thenReturn(testCulvert);

        Culvert result = culvertService.createCulvert(testRequest);

        assertNotNull(result);
        assertEquals(testCulvert, result);
        verify(culvertRepository).findBySerialNumberContainingIgnoreCase(testRequest.getSerialNumber());
        verify(culvertRepository).save(any());
    }

    @Test
    void createCulvert_WhenSerialNumberExists_ShouldThrowException() {
        when(culvertRepository.findBySerialNumberContainingIgnoreCase(any()))
                .thenReturn(Arrays.asList(testCulvert));

        assertThrows(IllegalArgumentException.class, () -> culvertService.createCulvert(testRequest));
        verify(culvertRepository).findBySerialNumberContainingIgnoreCase(testRequest.getSerialNumber());
        verify(culvertRepository, never()).save(any());
    }

    @Test
    void updateCulvert_WhenCulvertExists_ShouldUpdateCulvert() {
        when(culvertRepository.findById("test-id-1")).thenReturn(Optional.of(testCulvert));
        when(culvertRepository.findBySerialNumberContainingIgnoreCase(any())).thenReturn(List.of());
        when(culvertRepository.save(any())).thenReturn(testCulvert);

        Culvert result = culvertService.updateCulvert("test-id-1", testRequest);

        assertNotNull(result);
        assertEquals(testCulvert, result);
        verify(culvertRepository).findById("test-id-1");
        verify(culvertRepository).findBySerialNumberContainingIgnoreCase(testRequest.getSerialNumber());
        verify(culvertRepository).save(any());
    }

    @Test
    void deleteCulvert_WhenCulvertExists_ShouldDeleteCulvert() {
        when(culvertRepository.existsById("test-id-1")).thenReturn(true);
        doNothing().when(culvertRepository).deleteById("test-id-1");

        assertDoesNotThrow(() -> culvertService.deleteCulvert("test-id-1"));
        verify(culvertRepository).existsById("test-id-1");
        verify(culvertRepository).deleteById("test-id-1");
    }

    @Test
    void deleteCulvert_WhenCulvertDoesNotExist_ShouldThrowException() {
        when(culvertRepository.existsById("non-existent")).thenReturn(false);

        assertThrows(ResourceNotFoundException.class, () -> culvertService.deleteCulvert("non-existent"));
        verify(culvertRepository).existsById("non-existent");
        verify(culvertRepository, never()).deleteById(any());
    }
} 