library project_http;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io' as io show Platform;

class HttpReturn {
  late int? httpCode;
  late Map<String, dynamic>? data;

  HttpReturn(this.httpCode, this.data);

  HttpReturn.empty();
}

class Http {
  var platform = io.Platform.operatingSystem; //Get l'os hôte
  var app = "dev";
  late String apiUrl;

  Http() {
    if (app == "dev" && platform == "android") {
      apiUrl = "http://10.0.2.2:8000";
    } else {
      apiUrl = "http://127.0.0.1:8000";
    }
  }

  Future<HttpReturn> request(String method, String url, {List? headers, List? body}) async {
    switch (method) {
      case "get":
        var response = await http.get(Uri.parse("https://httpbin.org/$url"));
        try {
          return HttpReturn(response.statusCode, jsonDecode(response.body));
        } on Exception {
          return HttpReturn.empty();
        }
      case "post":
        var response = await http.post(Uri.parse("https://httpbin.org/$url"));
        try {
          return HttpReturn(response.statusCode, jsonDecode(response.body));
        } on Exception {
          return HttpReturn.empty();
        }
    }
    return HttpReturn.empty();
  }

  login(String username, String password) async {
    var response = await http.get(Uri.parse("$apiUrl/user/login/$username/$password"));
    return response.body;
  }
}
