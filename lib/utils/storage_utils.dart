import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static Storage instance = Storage();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  String _guid = "";
  String _displayName = "";
  int _userType = 0;
  String _accessToken = "";
  String _refreshToken = "";
  String _fcmToken = "";

  Future<String> get username async =>
      (await _storage.read(key: "username")) ?? "";

  Future<String> get password async =>
      (await _storage.read(key: "password")) ?? "";

  void setGuid(String guid) {
    _guid = guid;
    _storage.write(key: "guid", value: guid);
  }

  Future<String> getGuid() async {
    if (_guid != "") return _guid;
    return (await _storage.read(key: "guid")) ?? "";
  }

  void setUsername(String username) =>
      _storage.write(key: "username", value: username);

  void setPassword(String password) =>
      _storage.write(key: "password", value: password);

  void setDisplayName(String displayName) {
    _displayName = displayName;
    _storage.write(key: "display-name", value: displayName);
  }

  void setUserType(int userType) {
    _userType = userType;
    _storage.write(key: "user-type", value: userType.toString());
  }

  Future<String> getDisplayName() async {
    if (_displayName != "") return _displayName;
    return (await _storage.read(key: "display-name")) ?? "";
  }

  Future<int> getUserType() async {
    if (_userType != -1) return _userType;
    return (int.parse(_storage.read(key: "user-type").toString()));
  }

  void setAccessToken(String accessToken) {
    _accessToken = accessToken;
    _storage.write(key: "access-token", value: accessToken);
  }

  Future<String> getAccessToken() async {
    if (_accessToken != "") return _accessToken;
    return (await _storage.read(key: "access-token")) ?? "";
  }

  void setRefreshToken(String refreshToken) {
    _refreshToken = refreshToken;
    _storage.write(key: "refresh-token", value: refreshToken);
  }

  Future<String> getRefreshToken() async {
    if (_refreshToken != "") return _refreshToken;
    return (await _storage.read(key: "refresh-token")) ?? "";
  }

  void setFcmToken(String fcmToken) {
    _fcmToken = fcmToken;
    _storage.write(key: "fcm-token", value: fcmToken);
  }

  Future<String> getFcmToken() async {
    if (_fcmToken != "") return _fcmToken;
    return (await _storage.read(key: "fcm-token")) ?? "";
  }

  void removeData() {
    _storage.delete(key: "guid");
    _storage.delete(key: "access-token");
    _storage.delete(key: "refresh-token");
  }

  void removeAll() => _storage.deleteAll();
}
