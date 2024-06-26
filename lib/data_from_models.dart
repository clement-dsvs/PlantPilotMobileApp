library local_data_object;

import "package:realm/realm.dart";
import "models/account.dart";
import "models/message.dart";
import "models/plant_pilot.dart";
import "models/pot.dart";
import "models/preset.dart";
import "models/topic.dart";

Account getAccount() {
  return Account(ObjectId(), "root", "root@root.com", true, true);
}

List<Topic> getTopics() {
  return [
    Topic(ObjectId(), "Discussion", "Francis", DateTime.now(), "Rebecca", DateTime.now(), 0),
    Topic(ObjectId(), "Quel quantité d'eau quotidienne pour une monstera ?", "Rebecca", DateTime.now(), "Bill", DateTime.now(), 0),
    Topic(ObjectId(), "Quel quantité d'eau pour mon rhododendron", "Michel", DateTime.now(), "Agnès", DateTime.now(), 0)
  ];
}

List<Message> getMessages(List<Topic> topics) {
  List<Message> messages = [];
  var topicIdIndex = 0;
  for (var i = 0; i < 6; i++) {
    if (i > 0 && i % 2 == 0) {
      topics[topicIdIndex].messageCount = 2;
      topicIdIndex++;
    }
    messages.add(Message(ObjectId(), topics[topicIdIndex].id, "Rebecca", DateTime.now(), "Votre message ici", responseTo: null, attachedPreset: null));
  }
  return messages;
}

List<PlantPilot> getPlantPilot() {
  return [PlantPilot(ObjectId(), "PlantPilot Maison", "active", DateTime.now())];
}

List<Pot> getPots(List<PlantPilot> plantPilot) {
  return [
    Pot(id: ObjectId(), name: "Rose", status: "active", waterLevel: 100, batteryLevel: 100, plantPilotId: plantPilot.first.id, humidity: 100),
    Pot(id: ObjectId(), name: "Orchidée", status: "active", waterLevel: 50, batteryLevel: 50, plantPilotId: plantPilot.first.id, humidity: 100),
    Pot(id: ObjectId(), name: "Pivoine", status: "active", waterLevel: 20, batteryLevel: 20, plantPilotId: plantPilot.first.id, humidity: 100),
  ];
}

/*
List<Preset> getPresets() {
  return [
    Preset(ObjectId(), "Preset 1", "root", DateTime.now(), 10, 1),
    Preset(ObjectId(), "Preset 2", "root", DateTime.now(), 50, 24),
    Preset(ObjectId(), "Preset 3", "root", DateTime.now(), 100, 48)
  ];
}*/
