library project_http;

import 'package:http/http.dart' as http;
import 'dart:io' as io show Platform;

class Http {
  var platform = io.Platform.operatingSystem; //Get l'os hôte
  var app = "dev";
  var apiUrl;

  Http() {
    if (app == "dev" && platform == "android") {
      apiUrl = "http://10.0.2.2:8000";
    } else {
      apiUrl = "http://127.0.0.1:8000";
    }
  }

  login(String username, String password) async {
    var response = await http.get(Uri.parse(apiUrl + "/user/login/$username/$password"));
    return response.body;
  }
}
