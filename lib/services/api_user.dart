import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/storage_utils.dart';

//TODO: Fix the logout

class ApiUser {
  String path = "${ApiServices.base}/user";

  Future<Map> login(String username, String password) async {
    String fcmToken = await Storage.instance.getFcmToken();
    Response response;

    try {
      response = await post(
        Uri.parse("${ApiServices.base}/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "loginName": username,
          "password": password,
          "fcmToken": fcmToken,
        }),
      );
    } catch (e) {
      debugPrint("Error: [Login] ${e.toString()}");
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

  Future<bool> authorized() async {
    String fcmToken = await Storage.instance.getFcmToken();

    Response response;
    try {
      response = await post(
        Uri.parse("${ApiServices.base}/authorized"),
        body: jsonEncode({"fcmToken": fcmToken}),
        headers: await ApiServices.getHeaders(isAccess: false),
      );
    } catch (e) {
      debugPrint("Error: [Login] ${e.toString()}");
      return false;
    }

    if (response.statusCode != HttpStatus.ok) {
      return false;
    }

    return true;
  }

  Future<bool> logout() async {
    Response response = await ApiServices.call(
      Method.post,
      Uri.parse("${ApiServices.base}/logout"),
    );

    if (response.statusCode != HttpStatus.ok) {
      return false;
    }

    return true;
  }

  Future<List> getDrivers() async {
    Response response = await ApiServices.call(
      Method.get,
      Uri.parse("$path/all/driver"),
    );

    if (response.statusCode != HttpStatus.ok) {
      return List.empty();
    }

    var body = json.decode(response.body);
    if (body == null) {
      return List.empty();
    }

    return body;
  }
}
