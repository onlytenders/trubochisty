package com.trubochisty.truboserver.controller;

import com.trubochisty.truboserver.dto.request.CulvertRequest;
import com.trubochisty.truboserver.dto.response.CulvertResponse;
import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.service.CulvertService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/culverts")
@RequiredArgsConstructor
public class CulvertController {
    private final CulvertService culvertService;

    @GetMapping
    public ResponseEntity<List<CulvertResponse>> getAllCulverts() {
        return ResponseEntity.ok(culvertService.getAllCulverts().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<CulvertResponse> getCulvertById(@PathVariable String id) {
        return ResponseEntity.ok(mapToResponse(culvertService.getCulvertById(id)));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('ENGINEER')")
    public ResponseEntity<CulvertResponse> createCulvert(@Valid @RequestBody CulvertRequest request) {
        return ResponseEntity.ok(mapToResponse(culvertService.createCulvert(request)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('ENGINEER')")
    public ResponseEntity<CulvertResponse> updateCulvert(
            @PathVariable String id,
            @Valid @RequestBody CulvertRequest request) {
        return ResponseEntity.ok(mapToResponse(culvertService.updateCulvert(id, request)));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('ENGINEER')")
    public ResponseEntity<Void> deleteCulvert(@PathVariable String id) {
        culvertService.deleteCulvert(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<CulvertResponse>> searchCulverts(@RequestParam String query) {
        return ResponseEntity.ok(culvertService.searchCulverts(query).stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList()));
    }

    private CulvertResponse mapToResponse(Culvert culvert) {
        CulvertResponse response = new CulvertResponse();
        response.setId(culvert.getId());
        response.setAddress(culvert.getAddress());
        response.setCoordinates(culvert.getCoordinates());
        response.setRoad(culvert.getRoad());
        response.setSerialNumber(culvert.getSerialNumber());
        response.setPipeType(culvert.getPipeType());
        response.setMaterial(culvert.getMaterial());
        response.setDiameter(Double.parseDouble(culvert.getDiameter()));
        response.setLength(Double.parseDouble(culvert.getLength()));
        response.setHeadType(culvert.getHeadType());
        response.setFoundationType(culvert.getFoundationType());
        response.setWorkType(culvert.getWorkType());
        response.setConstructionYear(Integer.parseInt(culvert.getConstructionYear()));
        response.setStrengthRating(culvert.getStrengthRating().intValue());
        response.setSafetyRating(culvert.getSafetyRating().intValue());
        response.setMaintainabilityRating(culvert.getMaintainabilityRating().intValue());
        response.setGeneralConditionRating(culvert.getGeneralConditionRating().intValue());
        return response;
    }
} 