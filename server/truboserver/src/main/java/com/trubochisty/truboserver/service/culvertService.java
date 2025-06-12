package com.trubochisty.truboserver.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.trubochisty.truboserver.dto.request.CulvertRequest;
import com.trubochisty.truboserver.exception.ResourceNotFoundException;
import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.repository.CulvertRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CulvertService {
    private final CulvertRepository culvertRepository;

    @Transactional(readOnly = true)
    public List<Culvert> getAllCulverts() {
        return culvertRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Culvert getCulvertById(String id) {
        return culvertRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Culvert not found with id: " + id));
    }

    @Transactional
    public Culvert createCulvert(CulvertRequest request) {
        if (culvertRepository.findBySerialNumberContainingIgnoreCase(request.getSerialNumber()).size() > 0) {
            throw new IllegalArgumentException("Culvert with this serial number already exists");
        }

        Culvert culvert = Culvert.builder()
                .address(request.getAddress())
                .coordinates(request.getCoordinates())
                .road(request.getRoad())
                .serialNumber(request.getSerialNumber())
                .pipeType(request.getPipeType())
                .material(request.getMaterial())
                .diameter(request.getDiameter())
                .length(request.getLength())
                .headType(request.getHeadType())
                .foundationType(request.getFoundationType())
                .workType(request.getWorkType())
                .constructionYear(request.getConstructionYear())
                .lastRepairDate(request.getLastRepairDate())
                .lastInspectionDate(request.getLastInspectionDate())
                .strengthRating(request.getStrengthRating())
                .safetyRating(request.getSafetyRating())
                .maintainabilityRating(request.getMaintainabilityRating())
                .generalConditionRating(request.getGeneralConditionRating())
                .defects(request.getDefects())
                .photos(request.getPhotos())
                .build();

        return culvertRepository.save(culvert);
    }

    @Transactional
    public Culvert updateCulvert(String id, CulvertRequest request) {
        Culvert existingCulvert = getCulvertById(id);

        // Check if serial number is being changed and if it's already in use
        if (!existingCulvert.getSerialNumber().equals(request.getSerialNumber()) &&
            culvertRepository.findBySerialNumberContainingIgnoreCase(request.getSerialNumber()).size() > 0) {
            throw new IllegalArgumentException("Culvert with this serial number already exists");
        }

        existingCulvert.setAddress(request.getAddress());
        existingCulvert.setCoordinates(request.getCoordinates());
        existingCulvert.setRoad(request.getRoad());
        existingCulvert.setSerialNumber(request.getSerialNumber());
        existingCulvert.setPipeType(request.getPipeType());
        existingCulvert.setMaterial(request.getMaterial());
        existingCulvert.setDiameter(request.getDiameter());
        existingCulvert.setLength(request.getLength());
        existingCulvert.setHeadType(request.getHeadType());
        existingCulvert.setFoundationType(request.getFoundationType());
        existingCulvert.setWorkType(request.getWorkType());
        existingCulvert.setConstructionYear(request.getConstructionYear());
        existingCulvert.setLastRepairDate(request.getLastRepairDate());
        existingCulvert.setLastInspectionDate(request.getLastInspectionDate());
        existingCulvert.setStrengthRating(request.getStrengthRating());
        existingCulvert.setSafetyRating(request.getSafetyRating());
        existingCulvert.setMaintainabilityRating(request.getMaintainabilityRating());
        existingCulvert.setGeneralConditionRating(request.getGeneralConditionRating());
        existingCulvert.setDefects(request.getDefects());
        existingCulvert.setPhotos(request.getPhotos());

        return culvertRepository.save(existingCulvert);
    }

    @Transactional
    public void deleteCulvert(String id) {
        if (!culvertRepository.existsById(id)) {
            throw new ResourceNotFoundException("Culvert not found with id: " + id);
        }
        culvertRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public List<Culvert> searchCulverts(String query) {
        return culvertRepository.search(query);
    }
}
