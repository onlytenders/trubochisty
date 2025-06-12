package com.trubochisty.truboserver.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.trubochisty.truboserver.model.Culvert;

@Repository
public interface CulvertRepository extends JpaRepository<Culvert, String> {
    List<Culvert> findBySerialNumberContainingIgnoreCase(String serialNumber);
    List<Culvert> findByAddressContainingIgnoreCase(String address);
    List<Culvert> findByRoadContainingIgnoreCase(String road);
    
    @Query("SELECT c FROM Culvert c WHERE " +
           "LOWER(c.address) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(c.road) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(c.serialNumber) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(c.coordinates) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<Culvert> search(String query);
}
