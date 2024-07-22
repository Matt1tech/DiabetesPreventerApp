import 'package:json_annotation/json_annotation.dart';

part 'physical_activity.g.dart';

@JsonSerializable()
class PhysicalActivity {
  String duration;
  String type;

  PhysicalActivity({
    required this.duration,
    required this.type,
  });

  factory PhysicalActivity.fromJson(Map<String, dynamic> json) =>
      _$PhysicalActivityFromJson(json);
  Map<String, dynamic> toJson() => _$PhysicalActivityToJson(this);
}
