import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

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

  static Future<String?> get password async {
    return _storage.read(key: "password");
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
    password = "",
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

    if (password != "") {
      await _storage.write(key: "password", value: password);
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
}
