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
        "Dashboard": {"icon": Icon(Icons.home), "page": HomePage()}
      },
      {
        "Presets": {
          "icon": Icon(Icons.precision_manufacturing),
          "page": PresetsPage()
        }
      },
      {
        "Forum": {"icon": Icon(Icons.forum), "page": ForumPage()}
      },
      {
        "Mon compte": {"icon": Icon(Icons.person), "page": AccountPage()}
      }
    ];
  }
}