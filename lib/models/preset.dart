import 'package:realm/realm.dart';

part 'preset.realm.dart';

@RealmModel()
class _Preset {
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late String createdBy;
  late DateTime createdAt;
  late int waterQuantity;
  late int timeInterval;
}