// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pot.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Pot extends _Pot with RealmEntity, RealmObjectBase, RealmObject {
  Pot(
    ObjectId id,
    String name,
    String status,
    int waterLevel,
    int batteryLevel,
    ObjectId plantPilotId,
    int humidity, {
    ObjectId? preset,
    DateTime? lastWatering,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'waterLevel', waterLevel);
    RealmObjectBase.set(this, 'batteryLevel', batteryLevel);
    RealmObjectBase.set(this, 'plantPilotId', plantPilotId);
    RealmObjectBase.set(this, 'preset', preset);
    RealmObjectBase.set(this, 'lastWatering', lastWatering);
    RealmObjectBase.set(this, 'humidity', humidity);
  }

  Pot._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  int get waterLevel => RealmObjectBase.get<int>(this, 'waterLevel') as int;
  @override
  set waterLevel(int value) => RealmObjectBase.set(this, 'waterLevel', value);

  @override
  int get batteryLevel => RealmObjectBase.get<int>(this, 'batteryLevel') as int;
  @override
  set batteryLevel(int value) =>
      RealmObjectBase.set(this, 'batteryLevel', value);

  @override
  ObjectId get plantPilotId =>
      RealmObjectBase.get<ObjectId>(this, 'plantPilotId') as ObjectId;
  @override
  set plantPilotId(ObjectId value) =>
      RealmObjectBase.set(this, 'plantPilotId', value);

  @override
  ObjectId? get preset =>
      RealmObjectBase.get<ObjectId>(this, 'preset') as ObjectId?;
  @override
  set preset(ObjectId? value) => RealmObjectBase.set(this, 'preset', value);

  @override
  DateTime? get lastWatering =>
      RealmObjectBase.get<DateTime>(this, 'lastWatering') as DateTime?;
  @override
  set lastWatering(DateTime? value) =>
      RealmObjectBase.set(this, 'lastWatering', value);

  @override
  int get humidity => RealmObjectBase.get<int>(this, 'humidity') as int;
  @override
  set humidity(int value) => RealmObjectBase.set(this, 'humidity', value);

  @override
  Stream<RealmObjectChanges<Pot>> get changes =>
      RealmObjectBase.getChanges<Pot>(this);

  @override
  Pot freeze() => RealmObjectBase.freezeObject<Pot>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'status': status.toEJson(),
      'waterLevel': waterLevel.toEJson(),
      'batteryLevel': batteryLevel.toEJson(),
      'plantPilotId': plantPilotId.toEJson(),
      'preset': preset.toEJson(),
      'lastWatering': lastWatering.toEJson(),
      'humidity': humidity.toEJson(),
    };
  }

  static EJsonValue _toEJson(Pot value) => value.toEJson();
  static Pot _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'status': EJsonValue status,
        'waterLevel': EJsonValue waterLevel,
        'batteryLevel': EJsonValue batteryLevel,
        'plantPilotId': EJsonValue plantPilotId,
        'preset': EJsonValue preset,
        'lastWatering': EJsonValue lastWatering,
        'humidity': EJsonValue humidity,
      } =>
        Pot(
          fromEJson(id),
          fromEJson(name),
          fromEJson(status),
          fromEJson(waterLevel),
          fromEJson(batteryLevel),
          fromEJson(plantPilotId),
          fromEJson(humidity),
          preset: fromEJson(preset),
          lastWatering: fromEJson(lastWatering),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Pot._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Pot, 'Pot', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('waterLevel', RealmPropertyType.int),
      SchemaProperty('batteryLevel', RealmPropertyType.int),
      SchemaProperty('plantPilotId', RealmPropertyType.objectid),
      SchemaProperty('preset', RealmPropertyType.objectid, optional: true),
      SchemaProperty('lastWatering', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('humidity', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
