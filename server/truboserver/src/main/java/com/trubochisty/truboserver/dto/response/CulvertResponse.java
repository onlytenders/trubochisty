package com.trubochisty.truboserver.dto.response;

import lombok.Data;
import lombok.Builder;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CulvertResponse {
    private String id;
    private String address;
    private String coordinates;
    private String road;
    private String serialNumber;
    private String pipeType;
    private String material;
    private Double diameter;
    private Double length;
    private String headType;
    private String foundationType;
    private String workType;
    private Integer constructionYear;
    private LocalDate lastRepairDate;
    private LocalDate lastInspectionDate;
    private Integer strengthRating;
    private Integer safetyRating;
    private Integer maintainabilityRating;
    private Integer generalConditionRating;
    private List<String> defects;
    private List<String> photos;
} 