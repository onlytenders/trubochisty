package com.trubochisty.truboserver.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.trubochisty.truboserver.model.Culvert;
import org.springframework.stereotype.Repository;

@Repository
public interface IculvertRepository extends JpaRepository<Culvert, Long> {
    
}
