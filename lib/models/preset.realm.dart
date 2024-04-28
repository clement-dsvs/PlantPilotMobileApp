// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Preset extends _Preset with RealmEntity, RealmObjectBase, RealmObject {
  Preset(
    ObjectId id,
    String name,
    String createdBy,
    DateTime createdAt,
    int waterQuantity,
    int timeInterval,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'createdBy', createdBy);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'waterQuantity', waterQuantity);
    RealmObjectBase.set(this, 'timeInterval', timeInterval);
  }

  Preset._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get createdBy =>
      RealmObjectBase.get<String>(this, 'createdBy') as String;
  @override
  set createdBy(String value) => RealmObjectBase.set(this, 'createdBy', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  int get waterQuantity =>
      RealmObjectBase.get<int>(this, 'waterQuantity') as int;
  @override
  set waterQuantity(int value) =>
      RealmObjectBase.set(this, 'waterQuantity', value);

  @override
  int get timeInterval => RealmObjectBase.get<int>(this, 'timeInterval') as int;
  @override
  set timeInterval(int value) =>
      RealmObjectBase.set(this, 'timeInterval', value);

  @override
  Stream<RealmObjectChanges<Preset>> get changes =>
      RealmObjectBase.getChanges<Preset>(this);

  @override
  Preset freeze() => RealmObjectBase.freezeObject<Preset>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'createdBy': createdBy.toEJson(),
      'createdAt': createdAt.toEJson(),
      'waterQuantity': waterQuantity.toEJson(),
      'timeInterval': timeInterval.toEJson(),
    };
  }

  static EJsonValue _toEJson(Preset value) => value.toEJson();
  static Preset _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'createdBy': EJsonValue createdBy,
        'createdAt': EJsonValue createdAt,
        'waterQuantity': EJsonValue waterQuantity,
        'timeInterval': EJsonValue timeInterval,
      } =>
        Preset(
          fromEJson(id),
          fromEJson(name),
          fromEJson(createdBy),
          fromEJson(createdAt),
          fromEJson(waterQuantity),
          fromEJson(timeInterval),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Preset._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Preset, 'Preset', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('createdBy', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('waterQuantity', RealmPropertyType.int),
      SchemaProperty('timeInterval', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
