package com.trubochisty.truboserver.service;

import com.trubochisty.truboserver.model.Culvert;
import com.trubochisty.truboserver.repository.ICulvertRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CulvertService {
    private final ICulvertRepository culvertRepository;

    public Culvert getCulvert(String id) {
        return culvertRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Culvert not found with id: " + id));
    }

    public List<Culvert> getAllCulverts() {
        return culvertRepository.findAll();
    }

    public List<Culvert> getCulvertsByAddress(String address) {
        return culvertRepository.findByAddressContainingIgnoreCase(address);
    }

    public Culvert createCulvert(Culvert culvert) {
        return culvertRepository.save(culvert);
    }

    public Culvert updateCulvert(String id, Culvert updated) {
        Culvert existing = culvertRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Culvert not found with id: " + id));

        existing.setAddress(updated.getAddress());
        existing.setCoordinates(updated.getCoordinates());
        existing.setRoad(updated.getRoad());
        existing.setSerialNumber(updated.getSerialNumber());
        existing.setPipeType(updated.getPipeType());
        existing.setMaterial(updated.getMaterial());
        existing.setDiameter(updated.getDiameter());
        existing.setLength(updated.getLength());
        existing.setHeadType(updated.getHeadType());
        existing.setFoundationType(updated.getFoundationType());
        existing.setWorkType(updated.getWorkType());
        existing.setConstructionDate(updated.getConstructionDate());
        existing.setLastRepairDate(updated.getLastRepairDate());
        existing.setLastInspectionDate(updated.getLastInspectionDate());
        existing.setStrengthRating(updated.getStrengthRating());
        existing.setSafetyRating(updated.getSafetyRating());
        existing.setMaintainabilityRating(updated.getMaintainabilityRating());
        existing.setGeneralConditionRating(updated.getGeneralConditionRating());
        existing.setDefects(updated.getDefects());
        existing.setPhotos(updated.getPhotos());

        return culvertRepository.save(existing);
    }

    public void deleteCulvert(String id) {
        if (!culvertRepository.existsById(id)) {
            throw new RuntimeException("Culvert not found with id: " + id);
        }

        culvertRepository.deleteById(id);
    }

    public Page<Culvert> getAllCulvertsPageable(Pageable pageable) {
        return culvertRepository.findAll(pageable);
    }

    //TO-DO
    public Page<Culvert> getCulvertsByUserId(String userId, Pageable pageable) {
        return null;
    }
}

