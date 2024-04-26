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
    Topic(ObjectId(), "Topic 1", "root", DateTime.now(), "root", DateTime.now(), 0),
    Topic(ObjectId(), "Topic 2", "root", DateTime.now(), "root", DateTime.now(), 0),
    Topic(ObjectId(), "Topic 3", "root", DateTime.now(), "root", DateTime.now(), 0)
  ];
}

List<Message> getMessages(List<Topic> topics) {
  List<Message> messages = [];
  var topicIdIndex = 0;
  for (var i = 0; i < 6; i++) {
    if (i > 0 && i % 2 == 0) {
      topicIdIndex++;
    }
    messages.add(Message(ObjectId(), topics[topicIdIndex].id, "root", DateTime.now(), "Message $i", responseTo: null, attachedPreset: null));
  }
  return messages;
}

List<PlantPilot> getPlantPilot() {
  return [PlantPilot(ObjectId(), "active", DateTime.now())];
}

List<Pot> getPots(List<PlantPilot> plantPilot) {
  return [
    Pot(ObjectId(), "Pot 1", "active", 100, 100, plantPilot.first.id, preset: null, lastUsage: null),
    Pot(ObjectId(), "Pot 2", "active", 50, 50, plantPilot.first.id, preset: null, lastUsage: null),
    Pot(ObjectId(), "Pot 3", "active", 20, 20, plantPilot.first.id, preset: null, lastUsage: null)
  ];
}

List<Preset> getPresets() {
  return [
    Preset(ObjectId(), "Preset 1", "root", DateTime.now(), 10, 1),
    Preset(ObjectId(), "Preset 2", "root", DateTime.now(), 50, 24),
    Preset(ObjectId(), "Preset 3", "root", DateTime.now(), 100, 48)
  ];
}