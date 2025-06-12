import 'package:json_annotation/json_annotation.dart';

part 'culvert.g.dart';

@JsonSerializable()
class Culvert {
  final String id;
  final String address;
  final String coordinates;
  final String road;
  final String serialNumber;
  final String pipeType;
  final String material;
  final double diameter;
  final double length;
  final String headType;
  final String foundationType;
  final String workType;
  final int constructionYear;
  final DateTime? lastRepairDate;
  final DateTime? lastInspectionDate;
  final double strengthRating;
  final double safetyRating;
  final double maintainabilityRating;
  final double generalConditionRating;
  final List<String> defects;
  final List<String> photos;

  Culvert({
    required this.id,
    required this.address,
    required this.coordinates,
    required this.road,
    required this.serialNumber,
    required this.pipeType,
    required this.material,
    required this.diameter,
    required this.length,
    required this.headType,
    required this.foundationType,
    required this.workType,
    required this.constructionYear,
    this.lastRepairDate,
    this.lastInspectionDate,
    required this.strengthRating,
    required this.safetyRating,
    required this.maintainabilityRating,
    required this.generalConditionRating,
    required this.defects,
    required this.photos,
  });

  factory Culvert.fromJson(Map<String, dynamic> json) => _$CulvertFromJson(json);
  Map<String, dynamic> toJson() => _$CulvertToJson(this);
} 