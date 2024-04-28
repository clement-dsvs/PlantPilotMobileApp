// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Message extends _Message with RealmEntity, RealmObjectBase, RealmObject {
  Message(
    ObjectId id,
    ObjectId topicId,
    String createdBy,
    DateTime createdAt,
    String message, {
    String? responseTo,
    ObjectId? attachedPreset,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'topicId', topicId);
    RealmObjectBase.set(this, 'createdBy', createdBy);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'message', message);
    RealmObjectBase.set(this, 'responseTo', responseTo);
    RealmObjectBase.set(this, 'attachedPreset', attachedPreset);
  }

  Message._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get topicId =>
      RealmObjectBase.get<ObjectId>(this, 'topicId') as ObjectId;
  @override
  set topicId(ObjectId value) => RealmObjectBase.set(this, 'topicId', value);

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
  String get message => RealmObjectBase.get<String>(this, 'message') as String;
  @override
  set message(String value) => RealmObjectBase.set(this, 'message', value);

  @override
  String? get responseTo =>
      RealmObjectBase.get<String>(this, 'responseTo') as String?;
  @override
  set responseTo(String? value) =>
      RealmObjectBase.set(this, 'responseTo', value);

  @override
  ObjectId? get attachedPreset =>
      RealmObjectBase.get<ObjectId>(this, 'attachedPreset') as ObjectId?;
  @override
  set attachedPreset(ObjectId? value) =>
      RealmObjectBase.set(this, 'attachedPreset', value);

  @override
  Stream<RealmObjectChanges<Message>> get changes =>
      RealmObjectBase.getChanges<Message>(this);

  @override
  Message freeze() => RealmObjectBase.freezeObject<Message>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'topicId': topicId.toEJson(),
      'createdBy': createdBy.toEJson(),
      'createdAt': createdAt.toEJson(),
      'message': message.toEJson(),
      'responseTo': responseTo.toEJson(),
      'attachedPreset': attachedPreset.toEJson(),
    };
  }

  static EJsonValue _toEJson(Message value) => value.toEJson();
  static Message _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'topicId': EJsonValue topicId,
        'createdBy': EJsonValue createdBy,
        'createdAt': EJsonValue createdAt,
        'message': EJsonValue message,
        'responseTo': EJsonValue responseTo,
        'attachedPreset': EJsonValue attachedPreset,
      } =>
        Message(
          fromEJson(id),
          fromEJson(topicId),
          fromEJson(createdBy),
          fromEJson(createdAt),
          fromEJson(message),
          responseTo: fromEJson(responseTo),
          attachedPreset: fromEJson(attachedPreset),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Message._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Message, 'Message', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('topicId', RealmPropertyType.objectid),
      SchemaProperty('createdBy', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('message', RealmPropertyType.string),
      SchemaProperty('responseTo', RealmPropertyType.string, optional: true),
      SchemaProperty('attachedPreset', RealmPropertyType.objectid,
          optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
