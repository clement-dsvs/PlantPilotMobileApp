// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Account extends _Account with RealmEntity, RealmObjectBase, RealmObject {
  Account(
    ObjectId id,
    String username,
    String email,
    bool isActive,
    bool isAdmin,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'username', username);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'isAdmin', isAdmin);
  }

  Account._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get username =>
      RealmObjectBase.get<String>(this, 'username') as String;
  @override
  set username(String value) => RealmObjectBase.set(this, 'username', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  bool get isActive => RealmObjectBase.get<bool>(this, 'isActive') as bool;
  @override
  set isActive(bool value) => RealmObjectBase.set(this, 'isActive', value);

  @override
  bool get isAdmin => RealmObjectBase.get<bool>(this, 'isAdmin') as bool;
  @override
  set isAdmin(bool value) => RealmObjectBase.set(this, 'isAdmin', value);

  @override
  Stream<RealmObjectChanges<Account>> get changes =>
      RealmObjectBase.getChanges<Account>(this);

  @override
  Account freeze() => RealmObjectBase.freezeObject<Account>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'username': username.toEJson(),
      'email': email.toEJson(),
      'isActive': isActive.toEJson(),
      'isAdmin': isAdmin.toEJson(),
    };
  }

  static EJsonValue _toEJson(Account value) => value.toEJson();
  static Account _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'username': EJsonValue username,
        'email': EJsonValue email,
        'isActive': EJsonValue isActive,
        'isAdmin': EJsonValue isAdmin,
      } =>
        Account(
          fromEJson(id),
          fromEJson(username),
          fromEJson(email),
          fromEJson(isActive),
          fromEJson(isAdmin),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Account._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Account, 'Account', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('username', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('isAdmin', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
