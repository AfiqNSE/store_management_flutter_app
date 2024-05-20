import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/services/api_other.dart';
import 'package:store_management_system/services/api_pallet.dart';
import 'package:store_management_system/services/api_signature.dart';
import 'package:store_management_system/services/api_user.dart';
import 'package:store_management_system/utils/global_utils.dart';
import 'package:store_management_system/utils/storage_utils.dart';

enum Method { get, post, patch, delete }

class ApiServices {
  // static String base = "http://103.230.124.241:8220"; // Test Server
  static String base = "http://10.0.2.2:8220"; // Emulator
  // static String base = "http://localhost:8220"; // Device

  static ApiUser user = ApiUser();
  static ApiPallet pallet = ApiPallet();
  static ApiOther other = ApiOther();
  static ApiSignature signature = ApiSignature();

  static Future<Map<String, String>> getHeaders({bool isAccess = true}) async {
    Map<String, String> headers = {"Content-Type": "application/json"};
    headers.addAll(await getGuidHeader());
    headers.addAll(await getTokenHeaders(isAccess: isAccess));

    return headers;
  }

  static Future<Map<String, String>> getGuidHeader() async {
    return {"Guid": await Storage.instance.getGuid()};
  }

  static Future<Map<String, String>> getTokenHeaders(
      {bool isAccess = true}) async {
    String h = isAccess ? "access" : "refresh";

    String token = isAccess
        ? await Storage.instance.getAccessToken()
        : await Storage.instance.getRefreshToken();

    return {"Authorization": "$h $token"};
  }

  static Future<Response> call(
    Method method,
    Uri uri, {
    String body = "",
  }) async {
    Response response;

    try {
      response = await _send(method, uri, body: body);
    } on Exception catch (e) {
      debugPrint("Error: [Api Call] $e");
      response = Response("", HttpStatus.internalServerError);
    }

    switch (response.statusCode) {
      case HttpStatus.ok:
        if (response.headers.containsKey('access')) {
          Storage.instance.setAccessToken(
            response.headers["access"].toString(),
          );
        }

        break;
      case HttpStatus.forbidden:
        Map<String, dynamic> resBody = jsonDecode(response.body);

        if (resBody["code"] == "token.expired") {
          debugPrint("[API] Token expired");
          Response refRes;

          try {
            refRes = await _send(method, uri, isAccess: false, body: body);
          } on Exception catch (e) {
            debugPrint("Error: [Api Call] $e");
            refRes = Response("", HttpStatus.internalServerError);
          }

          if (refRes.headers.containsKey('access')) {
            Storage.instance.setAccessToken(
              refRes.headers["access"].toString(),
            );

            if (refRes.headers.containsKey('refresh')) {
              Storage.instance.setRefreshToken(
                refRes.headers["refresh"].toString(),
              );
            }
          }

          return refRes;
        } else {
          debugPrint("[API] Forbidden: ${response.body}");
          Global.instance.isLoggedIn = false;
        }

        break;
    }

    return response;
  }

  static Future<Response> _send(
    Method method,
    Uri uri, {
    bool isAccess = true,
    String body = "",
  }) async {
    Map<String, String> headers = await getHeaders(isAccess: isAccess);
    switch (method) {
      case Method.get:
        return await get(uri, headers: headers);
      case Method.post:
        return await post(uri, headers: headers, body: body);
      case Method.patch:
        return await patch(uri, headers: headers, body: body);
      case Method.delete:
        return await delete(uri, headers: headers, body: body);
      default:
        return Response("", HttpStatus.internalServerError);
    }
  }
}
