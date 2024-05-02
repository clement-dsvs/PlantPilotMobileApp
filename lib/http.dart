library project_http;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io' as io show Platform;

class HttpReturn {
  late int? httpCode;
  late dynamic data;

  HttpReturn(this.httpCode, this.data);

  HttpReturn.empty() {
    httpCode = 500;
    data = <String, String>{};
  }
}

class Http {
  var platform = io.Platform.operatingSystem; //Get l'os hôte
  var app = "dev";
  late String apiUrl;

  Http() {
    if (app == "dev" && platform == "android") {
      apiUrl = "http://172.20.10.3:8000/";/*"http://10.0.2.2:8000/"*/;
    } else {
      apiUrl = "http://127.0.0.1:8000/";
    }
  }

  Future<HttpReturn> request({required String method, required String url, List? headers, dynamic body}) async {
    switch (method) {
      case "get":
        try {
          var response = await http.get(Uri.parse(apiUrl + url));
          return HttpReturn(response.statusCode, response.body);
        } on Exception {
          return HttpReturn.empty();
        }
      case "post":
        try {
          var response = await http.post(Uri.parse(apiUrl + url),
              headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'},
              body: jsonEncode(body));
          return HttpReturn(response.statusCode, response.body);
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
