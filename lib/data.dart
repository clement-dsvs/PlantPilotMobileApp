library local_data;

class LocalData {
  var account = {
    "username": "roo",
    "password": "toor",
    "email": "ose",
    "is_active": true,
    "isAdmin": false
  };

  var plantPilot = [
    {"id": "1234",
      "status": "active",
      "last_message": "2000-01-01 00:00:00",
      "type": "base"},
    {"id": "4567",
      "status": "inactive",
      "last_message": "2000-01-01 00:00:00",
      "type": "base"}
  ];

  var pots = [
    {
      "id": "123",
      "status": "active",
      "water_level": 100,
      "battery_level": 100,
      "plantpilot_id": "1234",
      "preset": "null",
      "last_usage": "2000-01-01 00:00:00",
      "type": "pot"
    },
    {
      "id": "234",
      "status": "inactive",
      "water_level": 100,
      "battery_level": 100,
      "plantpilot_id": "1234",
      "preset": "null",
      "last_usage": "2000-01-01 00:00:00",
      "type": "pot"
    },
    {
      "id": "345",
      "status": "inactive",
      "water_level": 100,
      "battery_level": 100,
      "plantpilot_id": "4567",
      "preset": "null",
      "last_usage": "2000-01-01 00:00:00",
      "type": "pot"
    },
    {
      "id": "456",
      "status": "active",
      "water_level": 100,
      "battery_level": 100,
      "plantpilot_id": "4567",
      "preset": "null",
      "last_usage": "2000-01-01 00:00:00",
      "type": "pot"
    },
    {
      "id": "567",
      "status": "active",
      "water_level": 100,
      "battery_level": 100,
      "plantpilot_id": "1234",
      "preset": "null",
      "last_usage": "2000-01-01 00:00:00",
      "type": "pot"
    },
    {
      "id": "678",
      "status": "inactive",
      "water_level": 100,
      "battery_level": 100,
      "plantpilot_id": "1234",
      "preset": "null",
      "last_usage": "2000-01-01 00:00:00",
      "type": "pot"
    },
    {
      "id": "789",
      "status": "active",
      "water_level": 100,
      "battery_level": 100,
      "plantpilot_id": "4567",
      "preset": "null",
      "last_usage": "2000-01-01 00:00:00",
      "type": "pot"
    }
  ];

  var presets = [
    {
      "id": "123",
      "preset_name": "preset 1",
      "created_by": "user1",
      "created_at": "01-01-2000 00:00:00",
      "parameters": {
        "water_quantity": 100,
        "interval": 3600
      }
    },
    {
      "id": "456",
      "preset_name": "preset 2",
      "created_by": "user1",
      "created_at": "01-01-2000 00:00:00",
      "parameters": {
        "water_quantity": 100,
        "interval": 7200
      }
    }
  ];

  var topics = [
    {
      "id": "123",
      "topic_name": "topic1",
      "created_by": "user1",
      "created_at": "01-01-2000 00:00:00",
      "last_message_by": "user1",
      "last_message_at": "01-01-2000 00:00:00",
      "total_messages": 0
    },
    {
      "id": "456",
      "topic_name": "topic2",
      "created_by": "user2",
      "created_at": "01-01-2000 00:00:00",
      "last_message_by": "user2",
      "last_message_at": "01-01-2000 00:00:00",
      "total_messages": 0
    }
  ];

  var message = [
    {
      "id": "123",
      "topic_id": "topic1",
      "created_by": "user1",
      "created_at": "01-01-2000 00:00:00",
      "message": "message 1",
      "response_to": null,
      "modified_at": "01-01-2000 00:00:00",
      "previous_message": null
    },
    {
      "id": "234",
      "topic_id": "topic1",
      "created_by": "user2",
      "created_at": "01-01-2000 00:00:00",
      "message": "message 2",
      "response_to": null,
      "modified_at": "01-01-2000 00:00:00",
      "previous_message": null
    },
    {
      "id": "345",
      "topic_id": "topic2",
      "created_by": "user1",
      "created_at": "01-01-2000 00:00:00",
      "message": "message 3",
      "response_to": null,
      "modified_at": "01-01-2000 00:00:00",
      "previous_message": null
    },
    {
      "id": "456",
      "topic_id": "topic2",
      "created_by": "user2",
      "created_at": "01-01-2000 00:00:00",
      "message": "message 4",
      "response_to": null,
      "modified_at": "01-01-2000 00:00:00",
      "previous_message": null
    }
  ];
}