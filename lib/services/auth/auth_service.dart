import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

import '../../locator.dart';
import '../../resources/endpoints.dart';
import '../../resources/strings.dart';
import '../../shared/GlobalCache.dart';

class AuthService {
  // FetchService _fetchService;
  static final AuthService _auth = AuthService._internal();

  factory AuthService() => _auth;

  AuthService._internal() {
    initState();
  }

  Future<void> initState() async {
    await _openEncryptedBox();
  }

  var _box;
  Future<int> signInWithEmailPassword(Map<String, String> data) async {
    var jsonData;
    try {
      var res = await http.post(Uri.parse(EndPoints.HOST + EndPoints.LOGIN),
          body: data);
      print("GOT CODE FOR LOGIN ${res.statusCode}");
      if (res.statusCode == 200) {
        jsonData = json.decode(res.body);
        await _encrypt(jsonData["access"], jsonData["refresh"]);
        return 0;
      }
      return -2;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  Future<bool>? _refreshInFlight;

  // Concurrent callers (app-resume listener, parallel 401 retries) must share
  // one refresh attempt instead of racing separate requests on the same token.
  Future<bool> refreshToken() {
    return _refreshInFlight ??= _doRefreshToken().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<bool> _doRefreshToken() async {
    var _jsonData;
    String? _refresh = _box.get('refresh');
    if (_refresh == null || _refresh.isEmpty) return false;
    try {
      var _res = await http.post(
        Uri.parse(EndPoints.HOST + EndPoints.REFRESH),
        body: {'refresh': _refresh},
      );
      if (_res.statusCode == 200) {
        _jsonData = json.decode(_res.body);
        await _box.put('access', _jsonData['access']);
        if (_jsonData['refresh'] != null &&
            (_jsonData['refresh'] as String).isNotEmpty) {
          await _box.put('refresh', _jsonData['refresh']);
        }
        return true;
      }
      // Only an explicit 401/403 means the refresh token itself is dead
      // (expired/blacklisted). Other non-200s (5xx, 429, ...) are server-side
      // trouble, not proof the session is invalid, so don't wipe it for those.
      if (_res.statusCode == 401 || _res.statusCode == 403) {
        await logOut();
      }
      return false;
    } catch (e) {
      // Network/parse failure: the refresh token may still be valid, so don't
      // wipe the session over a transient error.
      print(e.toString());
      return false;
    }
  }

  bool authStateListener() {
    return !(_box.get('access', defaultValue: '') == '');
  }

  dynamic logOut() async {
    GlobalCache _cache = locator<GlobalCache>();
    _cache.branchWiseResults = null;
    _cache.companyWiseResults = null;
    _cache.filterFields = null;
    _cache.profilesForMe = null;
    _cache.profilesOpenForAll = null;
    _cache.candidateData = null;
    await _box.delete('access');
    await _box.delete('refresh');
    return true;
  }

  _encrypt(String access, String refresh) async {
    await _box.put('access', access);
    await _box.put('refresh', refresh);
  }

  fetchHeaderProvider(String endpoint) async {
    String _access = _box.get('access', defaultValue: '');
    return {'Authorization': 'Bearer ' + _access};
  }

  Future<void> _openEncryptedBox() async {
    print("initialising box");
    await Hive.initFlutter();
    await Hive.openBox(Strings.AUTH_BOX);
    _box = Hive.box(Strings.AUTH_BOX);
    await refreshToken();
  }
}
