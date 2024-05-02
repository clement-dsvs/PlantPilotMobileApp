import 'package:realm/realm.dart';

class Pot {
  final ObjectId id;
  String name;
  String status;
  int waterLevel;
  int batteryLevel;
  ObjectId plantPilotId;
  ObjectId? preset;
  DateTime? lastWatering;
  int humidity;

  Pot({
    required this.id,
    required this.name,
    required this.status,
    required this.waterLevel,
    required this.batteryLevel,
    required this.plantPilotId,
    this.preset,
    this.lastWatering,
    required this.humidity
  });

  factory Pot.fromJson(dynamic json) {
    return switch (json) {
      {
      '_id': ObjectId id,
      'name': String name,
      'status': String status,
      "water_level": int waterLevel,
      "humidity": int humidity,
      "battery_level": int batteryLevel,
      } =>
          Pot(id: id, name: name, status: status, waterLevel: waterLevel, batteryLevel: batteryLevel, plantPilotId: ObjectId(), humidity: humidity),
      _ => throw const FormatException('Failed to load pot.'),
    };
  }
}