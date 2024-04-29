import 'package:realm/realm.dart';

part 'plant_pilot.realm.dart';

@RealmModel()
class _PlantPilot {
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late String status;
  late DateTime lastMessage;
}