import 'package:realm/realm.dart';

part 'account.realm.dart';

@RealmModel()
class _Account {
  @PrimaryKey()
  late ObjectId id;
  late String username;
  late String email;
  late bool isActive;
  late bool isAdmin;
}