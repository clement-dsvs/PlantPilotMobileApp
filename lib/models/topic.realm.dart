// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Topic extends _Topic with RealmEntity, RealmObjectBase, RealmObject {
  Topic(
    ObjectId id,
    String name,
    String createdBy,
    DateTime createdAt,
    String lastMessageBy,
    DateTime lastMessageAt,
    int messageCount,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'createdBy', createdBy);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'lastMessageBy', lastMessageBy);
    RealmObjectBase.set(this, 'lastMessageAt', lastMessageAt);
    RealmObjectBase.set(this, 'messageCount', messageCount);
  }

  Topic._();

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
  String get lastMessageBy =>
      RealmObjectBase.get<String>(this, 'lastMessageBy') as String;
  @override
  set lastMessageBy(String value) =>
      RealmObjectBase.set(this, 'lastMessageBy', value);

  @override
  DateTime get lastMessageAt =>
      RealmObjectBase.get<DateTime>(this, 'lastMessageAt') as DateTime;
  @override
  set lastMessageAt(DateTime value) =>
      RealmObjectBase.set(this, 'lastMessageAt', value);

  @override
  int get messageCount => RealmObjectBase.get<int>(this, 'messageCount') as int;
  @override
  set messageCount(int value) =>
      RealmObjectBase.set(this, 'messageCount', value);

  @override
  Stream<RealmObjectChanges<Topic>> get changes =>
      RealmObjectBase.getChanges<Topic>(this);

  @override
  Topic freeze() => RealmObjectBase.freezeObject<Topic>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'createdBy': createdBy.toEJson(),
      'createdAt': createdAt.toEJson(),
      'lastMessageBy': lastMessageBy.toEJson(),
      'lastMessageAt': lastMessageAt.toEJson(),
      'messageCount': messageCount.toEJson(),
    };
  }

  static EJsonValue _toEJson(Topic value) => value.toEJson();
  static Topic _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'createdBy': EJsonValue createdBy,
        'createdAt': EJsonValue createdAt,
        'lastMessageBy': EJsonValue lastMessageBy,
        'lastMessageAt': EJsonValue lastMessageAt,
        'messageCount': EJsonValue messageCount,
      } =>
        Topic(
          fromEJson(id),
          fromEJson(name),
          fromEJson(createdBy),
          fromEJson(createdAt),
          fromEJson(lastMessageBy),
          fromEJson(lastMessageAt),
          fromEJson(messageCount),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Topic._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Topic, 'Topic', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('createdBy', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('lastMessageBy', RealmPropertyType.string),
      SchemaProperty('lastMessageAt', RealmPropertyType.timestamp),
      SchemaProperty('messageCount', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
