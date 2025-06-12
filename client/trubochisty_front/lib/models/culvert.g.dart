// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'culvert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Culvert _$CulvertFromJson(Map<String, dynamic> json) => Culvert(
      id: json['id'] as String,
      address: json['address'] as String,
      coordinates: json['coordinates'] as String,
      road: json['road'] as String,
      serialNumber: json['serialNumber'] as String,
      pipeType: json['pipeType'] as String,
      material: json['material'] as String,
      diameter: (json['diameter'] as num).toDouble(),
      length: (json['length'] as num).toDouble(),
      headType: json['headType'] as String,
      foundationType: json['foundationType'] as String,
      workType: json['workType'] as String,
      constructionYear: (json['constructionYear'] as num).toInt(),
      lastRepairDate: json['lastRepairDate'] == null
          ? null
          : DateTime.parse(json['lastRepairDate'] as String),
      lastInspectionDate: json['lastInspectionDate'] == null
          ? null
          : DateTime.parse(json['lastInspectionDate'] as String),
      strengthRating: (json['strengthRating'] as num).toDouble(),
      safetyRating: (json['safetyRating'] as num).toDouble(),
      maintainabilityRating: (json['maintainabilityRating'] as num).toDouble(),
      generalConditionRating:
          (json['generalConditionRating'] as num).toDouble(),
      defects:
          (json['defects'] as List<dynamic>).map((e) => e as String).toList(),
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CulvertToJson(Culvert instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'coordinates': instance.coordinates,
      'road': instance.road,
      'serialNumber': instance.serialNumber,
      'pipeType': instance.pipeType,
      'material': instance.material,
      'diameter': instance.diameter,
      'length': instance.length,
      'headType': instance.headType,
      'foundationType': instance.foundationType,
      'workType': instance.workType,
      'constructionYear': instance.constructionYear,
      'lastRepairDate': instance.lastRepairDate?.toIso8601String(),
      'lastInspectionDate': instance.lastInspectionDate?.toIso8601String(),
      'strengthRating': instance.strengthRating,
      'safetyRating': instance.safetyRating,
      'maintainabilityRating': instance.maintainabilityRating,
      'generalConditionRating': instance.generalConditionRating,
      'defects': instance.defects,
      'photos': instance.photos,
    };
