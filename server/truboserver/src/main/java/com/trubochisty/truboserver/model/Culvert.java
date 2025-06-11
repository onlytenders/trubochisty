package com.trubochisty.truboserver.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "culverts")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Culvert {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Identifying information
    @Column(nullable = false, length = 500)
    @NotBlank(message = "Address is required")
    private String address;

    @Column(nullable = false, length = 100)
    @NotBlank(message = "Coordinates are required")
    private String coordinates;

    @Column(nullable = false, length = 200)
    @NotBlank(message = "Road is required")
    private String road;

    @Column(name = "serial_number", unique = true, length = 100)
    @NotBlank(message = "Serial number is required")
    private String serialNumber;

    // Technical parameters
    @Column(name = "pipe_type", nullable = false, length = 100)
    @NotBlank(message = "Pipe type is required")
    private String pipeType;

    @Column(nullable = false, length = 100)
    @NotBlank(message = "Material is required")
    private String material;

    @Column(nullable = false, length = 50)
    @NotBlank(message = "Diameter is required")
    private String diameter;

    @Column(nullable = false, length = 50)
    @NotBlank(message = "Length is required")
    private String length;

    @Column(name = "head_type", nullable = false, length = 100)
    @NotBlank(message = "Head type is required")
    private String headType;

    @Column(name = "foundation_type", nullable = false, length = 100)
    @NotBlank(message = "Foundation type is required")
    private String foundationType;

    @Column(name = "work_type", nullable = false, length = 100)
    @NotBlank(message = "Work type is required")
    private String workType;

    // Additional information
    @Column(name = "construction_year", length = 4)
    private String constructionYear;

    @Column(name = "last_repair_date")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime lastRepairDate;

    @Column(name = "last_inspection_date")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime lastInspectionDate;

    // Condition ratings (0.0 to 10.0)
    @Column(name = "strength_rating")
    @DecimalMin(value = "0.0", message = "Strength rating must be between 0.0 and 10.0")
    @DecimalMax(value = "10.0", message = "Strength rating must be between 0.0 and 10.0")
    private Double strengthRating;

    @Column(name = "safety_rating")
    @DecimalMin(value = "0.0", message = "Safety rating must be between 0.0 and 10.0")
    @DecimalMax(value = "10.0", message = "Safety rating must be between 0.0 and 10.0")
    private Double safetyRating;

    @Column(name = "maintainability_rating")
    @DecimalMin(value = "0.0", message = "Maintainability rating must be between 0.0 and 10.0")
    @DecimalMax(value = "10.0", message = "Maintainability rating must be between 0.0 and 10.0")
    private Double maintainabilityRating;

    @Column(name = "general_condition_rating")
    @DecimalMin(value = "0.0", message = "General condition rating must be between 0.0 and 10.0")
    @DecimalMax(value = "10.0", message = "General condition rating must be between 0.0 and 10.0")
    private Double generalConditionRating;

    // Defects and photos as collections
    @ElementCollection
    @CollectionTable(name = "culvert_defects", joinColumns = @JoinColumn(name = "culvert_id"))
    @Column(name = "defect", length = 500)
    @Builder.Default
    private List<String> defects = new ArrayList<>();

    @ElementCollection
    @CollectionTable(name = "culvert_photos", joinColumns = @JoinColumn(name = "culvert_id"))
    @Column(name = "photo_url", length = 1000)
    @Builder.Default
    private List<String> photos = new ArrayList<>();

    // Audit fields
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    // Custom utility methods for managing collections
    public void addDefect(String defect) {
        if (this.defects == null) this.defects = new ArrayList<>();
        this.defects.add(defect);
    }

    public void addPhoto(String photoUrl) {
        if (this.photos == null) this.photos = new ArrayList<>();
        this.photos.add(photoUrl);
    }

    @Override
    public String toString() {
        return "Culvert{" +
                "id=" + id +
                ", serialNumber='" + serialNumber + '\'' +
                ", address='" + address + '\'' +
                ", road='" + road + '\'' +
                ", material='" + material + '\'' +
                '}';
    }
}
