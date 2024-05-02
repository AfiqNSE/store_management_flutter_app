import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static Storage instance = Storage();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  String _username = "";

  static Future<String?> get guid async {
    return _storage.read(key: "guid");
  }

  static Future<String?> get accessToken async {
    return _storage.read(key: "access-token");
  }

  static Future<String?> get refreshToken async {
    return _storage.read(key: "refresh-token");
  }

  static Future<String?> get user async {
    return _storage.read(key: "user");
  }

  static Future<String?> get fcmToken async {
    return _storage.read(key: "fcmToken");
  }

  static Future<String?> get fcmTokenOld async {
    return _storage.read(key: "fcmTokenOld");
  }

  static set({
    guid = "",
    accessToken = "",
    refreshToken = "",
    user = "",
    fcmToken = "",
  }) async {
    if (guid != "") {
      await _storage.write(key: "guid", value: guid);
    }

    if (accessToken != "") {
      await _storage.write(key: "access-token", value: accessToken);
    }

    if (refreshToken != "") {
      await _storage.write(key: "refresh-token", value: refreshToken);
    }

    if (user != "") {
      await _storage.write(key: "user", value: user);
    }

    if (fcmToken != "") {
      var oldFcm = await _storage.read(key: "fcmToken");

      if (oldFcm == null) {
        debugPrint("[Storage] Add FCM Token: $fcmToken");
        await _storage.write(key: "fcmToken", value: fcmToken);
      } else if (oldFcm != fcmToken) {
        debugPrint("[Storage] Replace FCM Token: $fcmToken");
        await _storage.write(key: "fcmTokenOld", value: oldFcm);
        await _storage.write(key: "fcmToken", value: fcmToken);
      }
    }
  }

  static removeAll() async {
    await _storage.delete(key: "guid");
    await _storage.delete(key: "access-token");
    await _storage.delete(key: "refresh-token");
  }

  void setUsername(String username) {
    _username = username;
    _storage.write(key: "username", value: username);
  }

  Future<String> getUsername() async {
    if (_username != "") return _username;

    return (await _storage.read(key: "username")) ?? "";
  }

  void setPassword(String password) {
    _storage.write(key: "password", value: password);
  }

  Future<String> getPassword() async {
    return (await _storage.read(key: "password")) ?? "";
  }
}
