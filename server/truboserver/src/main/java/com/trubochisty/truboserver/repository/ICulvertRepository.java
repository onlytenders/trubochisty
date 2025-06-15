package com.trubochisty.truboserver.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.trubochisty.truboserver.model.Culvert;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ICulvertRepository extends JpaRepository<Culvert, String> {
    List<Culvert> getCulvertById(String id);

    List<Culvert> getCulvertsByAddress(String address);

    List<Culvert> findByAddressContainingIgnoreCase(String address);
}
