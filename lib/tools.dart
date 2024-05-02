library project_tools;

import 'dart:io' as io show Platform;
import 'main.dart';
import "package:flutter/material.dart";

class Tools {
  var platform = io.Platform.operatingSystem; //Get l'os hôte
  var app = "dev";

  Tools() {
    print(platform);
  }

  List getMenuItems() {
    return [
      {
        "Dashboard": {"icon": const Icon(Icons.home), "page": const HomePage()}
      },
      {
        "Presets": {
          "icon": const Icon(Icons.precision_manufacturing),
          "page": const PresetsPage()
        }
      },
      {
        "Forum": {"icon": const Icon(Icons.forum), "page": const ForumPage()}
      },
      {
        "Mon compte": {"icon": const Icon(Icons.person), "page": const AccountPage()}
      }
    ];
  }
}