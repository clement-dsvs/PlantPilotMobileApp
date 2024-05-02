import 'package:realm/realm.dart';

class Preset {
  final ObjectId id;
  String name;
  String createdBy;
  DateTime createdAt;
  int waterQuantity;
  int timeInterval;

  Preset({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    required this.waterQuantity,
    required this.timeInterval
  });

  factory Preset.fromJson(dynamic json) {
    return switch (json) {
      {
      '_id': ObjectId id,
      'name': String name,
      'created_by': String createdBy,
      "created_at": DateTime createdAt,
      "water_quantity": int waterQuantity,
      "time_interval": int timeInterval,
      } =>
          Preset(id: id, name: name, createdBy: createdBy, createdAt: createdAt, waterQuantity: waterQuantity, timeInterval: timeInterval),
      _ => throw const FormatException('Failed to load preset.'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      '_id':  id.toString(),
      'name':  name,
      'created_by':  createdBy,
      "created_at":  createdAt.toString(),
      "water_quantity":  waterQuantity,
      "time_interval":  timeInterval
    };
  }
}