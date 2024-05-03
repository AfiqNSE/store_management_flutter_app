import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static Storage instance = Storage();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  String _guid = "";
  String _displayName = "";
  String _accessToken = "";
  String _refreshToken = "";

  String get guid => _guid;

  Future<String> get username async =>
      (await _storage.read(key: "username")) ?? "";

  Future<String> get password async =>
      (await _storage.read(key: "password")) ?? "";

  String get displayName => _displayName;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  void setGuid(String guid) {
    _guid = guid;
    _storage.write(key: "guid", value: guid);
  }

  Future<String> getGuid() async => (await _storage.read(key: "guid")) ?? "";

  void setUsername(String username) =>
      _storage.write(key: "username", value: username);

  void setPassword(String password) =>
      _storage.write(key: "password", value: password);

  void setDisplayName(String displayName) {
    _displayName = displayName;
    _storage.write(key: "display-name", value: displayName);
  }

  // Get the stored display name in FlutterSecureStorage
  Future<String> getDisplayName() async =>
      (await _storage.read(key: "display-name")) ?? "";

  void setAccessToken(String accessToken) {
    _accessToken = accessToken;
    _storage.write(key: "access-token", value: accessToken);
  }

  Future<String> getAccessToken() async =>
      (await _storage.read(key: "access-token")) ?? "";

  void setRefreshToken(String refreshToken) {
    _refreshToken = refreshToken;
    _storage.write(key: "refresh-token", value: refreshToken);
  }

  Future<String> getRefreshToken() async =>
      (await _storage.read(key: "refresh-token")) ?? "";

  void removeAll() => _storage.deleteAll();
}
