import 'package:realm/realm.dart';

part 'pot.realm.dart';

@RealmModel()
class _Pot {
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late String status;
  late int waterLevel;
  late int batteryLevel;
  late ObjectId plantPilotId;
  late ObjectId? preset;
  late DateTime? lastUsage;
}