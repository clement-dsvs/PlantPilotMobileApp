import 'package:realm/realm.dart';

part 'topic.realm.dart';

@RealmModel()
class _Topic {
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late String createdBy;
  late DateTime createdAt;
  late String lastMessageBy;
  late DateTime lastMessageAt;
  late int messageCount;
}