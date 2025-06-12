package com.trubochisty.truboserver.dto.request;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CulvertRequest {
    @NotBlank(message = "Address is required")
    private String address;

    @NotBlank(message = "Coordinates are required")
    private String coordinates;

    @NotBlank(message = "Road is required")
    private String road;

    @NotBlank(message = "Serial number is required")
    private String serialNumber;

    @NotBlank(message = "Pipe type is required")
    private String pipeType;

    @NotBlank(message = "Material is required")
    private String material;

    @NotBlank(message = "Diameter is required")
    private String diameter;

    @NotBlank(message = "Length is required")
    private String length;

    @NotBlank(message = "Head type is required")
    private String headType;

    @NotBlank(message = "Foundation type is required")
    private String foundationType;

    @NotBlank(message = "Work type is required")
    private String workType;

    @NotBlank(message = "Construction year is required")
    @Size(min = 4, max = 4, message = "Construction year must be 4 digits")
    private String constructionYear;

    private LocalDateTime lastRepairDate;
    private LocalDateTime lastInspectionDate;

    @NotNull(message = "Strength rating is required")
    private Double strengthRating;

    @NotNull(message = "Safety rating is required")
    private Double safetyRating;

    @NotNull(message = "Maintainability rating is required")
    private Double maintainabilityRating;

    @NotNull(message = "General condition rating is required")
    private Double generalConditionRating;

    private List<String> defects;
    private List<String> photos;
} 