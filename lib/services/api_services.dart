import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:store_management_system/services/api_user.dart';
import 'package:store_management_system/utils/global_utils.dart';
import 'package:store_management_system/utils/storage_utils.dart';

class ApiServices {
  // static String base = "http://103.230.124.241:8220"; // Test Server
  // static String base = "http://10.0.2.2:8220"; // Emulator
  static String base = "http://localhost:8220";

  static ApiUser user = ApiUser();
}

Future<Map<String, String>> getHeaders({bool isAccess = true}) async {
  Map<String, String> ret = {"Content-Type": "application/json; charset=UTF-8"};
  ret.addAll(await getGuidHeader());
  ret.addAll(await getTokenHeaders(isAccess: isAccess));
  return ret;
}

Future<Map<String, String>> getGuidHeader() async {
  return {"Guid": await Storage.guid ?? ""};
}

Future<Map<String, String>> getTokenHeaders({bool isAccess = true}) async {
  return {
    "Token": isAccess
        ? await Storage.accessToken ?? ""
        : await Storage.refreshToken ?? "",
    "Type": isAccess ? "access" : "refresh"
  };
}

Future<http.Response> apiCall(
  Uri uri, {
  bool isGet = true,
  String reqBody = "",
}) async {
  http.Response response = await _apiRequest(uri, isGet: isGet, body: reqBody);

  switch (response.statusCode) {
    case HttpStatus.ok:
      if (response.headers.containsKey('access')) {
        Storage.set(accessToken: response.headers["access"].toString());
      }

      break;
    case HttpStatus.forbidden:
      Map<String, dynamic> body = jsonDecode(response.body);

      if (body["code"] == "token.expired") {
        debugPrint("[API] Token expired");
        http.Response refreshRes = await _apiRequest(
          uri,
          isGet: isGet,
          isAccess: false,
          body: reqBody,
        );

        if (refreshRes.headers.containsKey('access')) {
          Storage.set(accessToken: refreshRes.headers["access"].toString());

          if (refreshRes.headers.containsKey('refresh')) {
            Storage.set(refreshToken: refreshRes.headers["refresh"].toString());
          }
        }

        return refreshRes;
      } else {
        debugPrint("[API] Forbidden: ${response.body}");
        Global.instance.isLoggedIn = false;
      }

      break;
  }

  return response;
}

Future<http.Response> _apiRequest(
  Uri uri, {
  bool isGet = true,
  bool isAccess = true,
  String body = "",
}) async {
  Map<String, String> headers = await getHeaders(isAccess: isAccess);

  try {
    if (isGet) {
      return await http.get(uri, headers: headers);
    } else {
      return await http.post(uri, headers: headers, body: body);
    }
  } on Exception catch (e) {
    debugPrint("[Error: ApiRequest] $e");
    return http.Response("", HttpStatus.internalServerError);
  }
}
