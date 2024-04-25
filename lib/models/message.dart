import 'package:realm/realm.dart';

part 'message.realm.dart';

@RealmModel()
class _Message {
  @PrimaryKey()
  late ObjectId id;
  late ObjectId topicId;
  late String createdBy;
  late DateTime createdAt;
  late String message;
  late String? responseTo;
  late ObjectId? attachedPreset;
}