package com.trubochisty.truboserver.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.trubochisty.truboserver.dto.request.CulvertRequest;
import com.trubochisty.truboserver.dto.response.CulvertResponse;
import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.service.CulvertService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(CulvertController.class)
class CulvertControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private CulvertService culvertService;

    private Culvert testCulvert;
    private CulvertRequest testRequest;
    private CulvertResponse testResponse;

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

        testResponse = new CulvertResponse();
        testResponse.setId("test-id-1");
        testResponse.setAddress("Test Address 1");
        testResponse.setCoordinates("55.7558,37.6173");
        testResponse.setRoad("Test Road 1");
        testResponse.setSerialNumber("TEST-001");
        testResponse.setPipeType("Round");
        testResponse.setMaterial("Concrete");
        testResponse.setDiameter(1.5);
        testResponse.setLength(12.0);
        testResponse.setHeadType("Standard");
        testResponse.setFoundationType("Concrete");
        testResponse.setWorkType("New Construction");
        testResponse.setConstructionYear(2020);
        testResponse.setStrengthRating(4);
        testResponse.setSafetyRating(4);
        testResponse.setMaintainabilityRating(4);
        testResponse.setGeneralConditionRating(4);
    }

    @Test
    void getAllCulverts_ShouldReturnAllCulverts() throws Exception {
        List<Culvert> culverts = Arrays.asList(testCulvert);
        when(culvertService.getAllCulverts()).thenReturn(culverts);

        mockMvc.perform(get("/api/culverts"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(testCulvert.getId()))
                .andExpect(jsonPath("$[0].address").value(testCulvert.getAddress()));

        verify(culvertService).getAllCulverts();
    }

    @Test
    void getCulvertById_WhenCulvertExists_ShouldReturnCulvert() throws Exception {
        when(culvertService.getCulvertById("test-id-1")).thenReturn(testCulvert);

        mockMvc.perform(get("/api/culverts/test-id-1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(testCulvert.getId()))
                .andExpect(jsonPath("$.address").value(testCulvert.getAddress()));

        verify(culvertService).getCulvertById("test-id-1");
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void createCulvert_WhenValidRequest_ShouldCreateCulvert() throws Exception {
        when(culvertService.createCulvert(any())).thenReturn(testCulvert);

        mockMvc.perform(post("/api/culverts")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(testCulvert.getId()))
                .andExpect(jsonPath("$.address").value(testCulvert.getAddress()));

        verify(culvertService).createCulvert(any());
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void updateCulvert_WhenValidRequest_ShouldUpdateCulvert() throws Exception {
        when(culvertService.updateCulvert(eq("test-id-1"), any())).thenReturn(testCulvert);

        mockMvc.perform(put("/api/culverts/test-id-1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(testRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(testCulvert.getId()))
                .andExpect(jsonPath("$.address").value(testCulvert.getAddress()));

        verify(culvertService).updateCulvert(eq("test-id-1"), any());
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void deleteCulvert_WhenCulvertExists_ShouldDeleteCulvert() throws Exception {
        doNothing().when(culvertService).deleteCulvert("test-id-1");

        mockMvc.perform(delete("/api/culverts/test-id-1"))
                .andExpect(status().isNoContent());

        verify(culvertService).deleteCulvert("test-id-1");
    }

    @Test
    void searchCulverts_ShouldReturnMatchingCulverts() throws Exception {
        List<Culvert> culverts = Arrays.asList(testCulvert);
        when(culvertService.searchCulverts("test")).thenReturn(culverts);

        mockMvc.perform(get("/api/culverts/search")
                .param("query", "test"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(testCulvert.getId()))
                .andExpect(jsonPath("$[0].address").value(testCulvert.getAddress()));

        verify(culvertService).searchCulverts("test");
    }
} 