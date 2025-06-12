package com.trubochisty.truboserver.model;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "culverts")
public class Culvert {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String address;

    @Column(nullable = false)
    private String coordinates;

    @Column(nullable = false)
    private String road;

    @Column(nullable = false, unique = true)
    private String serialNumber;

    @Column(nullable = false)
    private String pipeType;

    @Column(nullable = false)
    private String material;

    @Column(nullable = false)
    private String diameter;

    @Column(nullable = false)
    private String length;

    @Column(nullable = false)
    private String headType;

    @Column(nullable = false)
    private String foundationType;

    @Column(nullable = false)
    private String workType;

    @Column(nullable = false)
    private String constructionYear;

    @Column
    private LocalDateTime lastRepairDate;

    @Column
    private LocalDateTime lastInspectionDate;

    @Column(nullable = false)
    private Double strengthRating;

    @Column(nullable = false)
    private Double safetyRating;

    @Column(nullable = false)
    private Double maintainabilityRating;

    @Column(nullable = false)
    private Double generalConditionRating;

    @ElementCollection
    private List<String> defects;

    @ElementCollection
    private List<String> photos;
}
