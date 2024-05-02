// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_pilot.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class PlantPilot extends _PlantPilot
    with RealmEntity, RealmObjectBase, RealmObject {
  PlantPilot(
    ObjectId id,
    String name,
    String status,
    DateTime lastMessage,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'lastMessage', lastMessage);
  }

  PlantPilot._();

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
  DateTime get lastMessage =>
      RealmObjectBase.get<DateTime>(this, 'lastMessage') as DateTime;
  @override
  set lastMessage(DateTime value) =>
      RealmObjectBase.set(this, 'lastMessage', value);

  @override
  Stream<RealmObjectChanges<PlantPilot>> get changes =>
      RealmObjectBase.getChanges<PlantPilot>(this);

  @override
  PlantPilot freeze() => RealmObjectBase.freezeObject<PlantPilot>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'status': status.toEJson(),
      'lastMessage': lastMessage.toEJson(),
    };
  }

  static EJsonValue _toEJson(PlantPilot value) => value.toEJson();
  static PlantPilot _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'status': EJsonValue status,
        'lastMessage': EJsonValue lastMessage,
      } =>
        PlantPilot(
          fromEJson(id),
          fromEJson(name),
          fromEJson(status),
          fromEJson(lastMessage),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PlantPilot._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, PlantPilot, 'PlantPilot', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('lastMessage', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
