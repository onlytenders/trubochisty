class CulvertData {
  // Identifying information
  String address;
  String coordinates;
  String road;
  String serialNumber;
  
  // Technical parameters
  String pipeType;
  String material;
  String diameter;
  String length;
  String headType;
  String foundationType;
  String workType;
  
  // Additional information
  String constructionYear;
  DateTime? lastRepairDate;
  DateTime? lastInspectionDate;
  
  // Condition ratings
  double strengthRating;
  double safetyRating;
  double maintainabilityRating;
  double generalConditionRating;
  
  // Defects and photos
  List<String> defects;
  List<String> photos;
  
  CulvertData({
    this.address = '',
    this.coordinates = '',
    this.road = '',
    this.serialNumber = '',
    this.pipeType = 'Круглая',
    this.material = 'Бетон',
    this.diameter = '',
    this.length = '',
    this.headType = 'Стандартная',
    this.foundationType = 'Стандартный',
    this.workType = 'Обследование',
    this.constructionYear = '',
    this.lastRepairDate,
    this.lastInspectionDate,
    this.strengthRating = 3.0,
    this.safetyRating = 3.0,
    this.maintainabilityRating = 3.0,
    this.generalConditionRating = 3.0,
    this.defects = const [],
    this.photos = const [],
  });
  
  // Convert to JSON for backend
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'coordinates': coordinates,
      'road': road,
      'serialNumber': serialNumber,
      'pipeType': pipeType,
      'material': material,
      'diameter': diameter,
      'length': length,
      'headType': headType,
      'foundationType': foundationType,
      'workType': workType,
      'constructionYear': constructionYear,
      'lastRepairDate': lastRepairDate?.toIso8601String(),
      'lastInspectionDate': lastInspectionDate?.toIso8601String(),
      'strengthRating': strengthRating,
      'safetyRating': safetyRating,
      'maintainabilityRating': maintainabilityRating,
      'generalConditionRating': generalConditionRating,
      'defects': defects,
      'photos': photos,
    };
  }
  
  // Create from JSON for backend
  factory CulvertData.fromJson(Map<String, dynamic> json) {
    return CulvertData(
      address: json['address'] ?? '',
      coordinates: json['coordinates'] ?? '',
      road: json['road'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      pipeType: json['pipeType'] ?? 'Круглая',
      material: json['material'] ?? 'Бетон',
      diameter: json['diameter'] ?? '',
      length: json['length'] ?? '',
      headType: json['headType'] ?? 'Стандартная',
      foundationType: json['foundationType'] ?? 'Стандартный',
      workType: json['workType'] ?? 'Обследование',
      constructionYear: json['constructionYear'] ?? '',
      lastRepairDate: json['lastRepairDate'] != null 
          ? DateTime.parse(json['lastRepairDate']) 
          : null,
      lastInspectionDate: json['lastInspectionDate'] != null 
          ? DateTime.parse(json['lastInspectionDate']) 
          : null,
      strengthRating: (json['strengthRating'] ?? 3.0).toDouble(),
      safetyRating: (json['safetyRating'] ?? 3.0).toDouble(),
      maintainabilityRating: (json['maintainabilityRating'] ?? 3.0).toDouble(),
      generalConditionRating: (json['generalConditionRating'] ?? 3.0).toDouble(),
      defects: List<String>.from(json['defects'] ?? []),
      photos: List<String>.from(json['photos'] ?? []),
    );
  }
  
  // Helper method to get display title
  String get displayTitle {
    if (address.isNotEmpty) return address;
    if (road.isNotEmpty) return road;
    if (serialNumber.isNotEmpty) return 'Труба №$serialNumber';
    return 'Новая труба';
  }
  
  // CopyWith method for efficient updates
  CulvertData copyWith({
    String? address,
    String? coordinates,
    String? road,
    String? serialNumber,
    String? pipeType,
    String? material,
    String? diameter,
    String? length,
    String? headType,
    String? foundationType,
    String? workType,
    String? constructionYear,
    DateTime? lastRepairDate,
    DateTime? lastInspectionDate,
    double? strengthRating,
    double? safetyRating,
    double? maintainabilityRating,
    double? generalConditionRating,
    List<String>? defects,
    List<String>? photos,
  }) {
    return CulvertData(
      address: address ?? this.address,
      coordinates: coordinates ?? this.coordinates,
      road: road ?? this.road,
      serialNumber: serialNumber ?? this.serialNumber,
      pipeType: pipeType ?? this.pipeType,
      material: material ?? this.material,
      diameter: diameter ?? this.diameter,
      length: length ?? this.length,
      headType: headType ?? this.headType,
      foundationType: foundationType ?? this.foundationType,
      workType: workType ?? this.workType,
      constructionYear: constructionYear ?? this.constructionYear,
      lastRepairDate: lastRepairDate ?? this.lastRepairDate,
      lastInspectionDate: lastInspectionDate ?? this.lastInspectionDate,
      strengthRating: strengthRating ?? this.strengthRating,
      safetyRating: safetyRating ?? this.safetyRating,
      maintainabilityRating: maintainabilityRating ?? this.maintainabilityRating,
      generalConditionRating: generalConditionRating ?? this.generalConditionRating,
      defects: defects ?? this.defects,
      photos: photos ?? this.photos,
    );
  }
  
  // Helper method for search matching
  bool matches(String searchQuery) {
    final query = searchQuery.toLowerCase();
    return address.toLowerCase().contains(query) ||
           road.toLowerCase().contains(query) ||
           serialNumber.toLowerCase().contains(query) ||
           coordinates.toLowerCase().contains(query) ||
           material.toLowerCase().contains(query) ||
           pipeType.toLowerCase().contains(query);
  }

  // Equality operator for efficient comparisons
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CulvertData) return false;
    return address == other.address &&
           coordinates == other.coordinates &&
           road == other.road &&
           serialNumber == other.serialNumber &&
           pipeType == other.pipeType &&
           material == other.material &&
           diameter == other.diameter &&
           length == other.length &&
           headType == other.headType &&
           foundationType == other.foundationType &&
           workType == other.workType &&
           constructionYear == other.constructionYear &&
           lastRepairDate == other.lastRepairDate &&
           lastInspectionDate == other.lastInspectionDate &&
           strengthRating == other.strengthRating &&
           safetyRating == other.safetyRating &&
           maintainabilityRating == other.maintainabilityRating &&
           generalConditionRating == other.generalConditionRating;
  }

  @override
  int get hashCode {
    return Object.hash(
      address,
      coordinates,
      road,
      serialNumber,
      pipeType,
      material,
      diameter,
      length,
      headType,
      foundationType,
      workType,
      constructionYear,
      lastRepairDate,
      lastInspectionDate,
      strengthRating,
      safetyRating,
      maintainabilityRating,
      generalConditionRating,
    );
  }
} 