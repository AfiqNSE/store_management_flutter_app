import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:store_management_system/services/api_services.dart';

class ApiUser {
  Future<Map> login(String username, String password) async {
    Response response;

    try {
      response = await post(
        Uri.parse("${ApiServices.base}/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "loginName": username,
          "password": password,
        }),
      );
    } catch (e) {
      debugPrint("[Login] ${e.toString()}");
      return {"err": 2};
    }

    if (response.statusCode == HttpStatus.badRequest) {
      debugPrint(response.body);
      return {"err": 1};
    }

    if (response.statusCode != HttpStatus.ok) {
      debugPrint(response.body);
      return {"err": 2};
    }

    return jsonDecode(response.body);
  }
}
