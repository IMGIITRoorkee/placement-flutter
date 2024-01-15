import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:placement/locator.dart';

import 'package:placement/resources/endpoints.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:placement/resources/strings.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/GlobalCache.dart';

class AuthService {
  late FetchService _fetchService;
  static final AuthService _auth = AuthService.internal();

  factory AuthService() => _auth;

  AuthService.internal() {
    initState();
  }

  void initState() {
    _openEncryptedBox();
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

  Future<void> refreshToken() async {
    var _jsonData;
    String? _refresh = _box.get('refresh');
    try {
      var _res = await http.post(
        Uri.parse(EndPoints.HOST + EndPoints.REFRESH),
        body: {'refresh': _refresh},
      );
      if (_res.statusCode == 200) {
        _jsonData = json.decode(_res.body);
        _encryptToken(_jsonData['access']);
      }
    } catch (e) {}
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
    String _access = await _box.get('access');
    return {'Authorization': 'Bearer ' + _access};
  }

  _encryptToken(String access) {
    _box.put('access', access);
  }

  _openEncryptedBox() async {
    print("initialising box");
    await Hive.initFlutter();
    await Hive.openBox(Strings.AUTH_BOX);
    _box = Hive.box(Strings.AUTH_BOX);
    refreshToken();
  }
}
