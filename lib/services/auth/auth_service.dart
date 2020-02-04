import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:placement/resources/endpoints.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:placement/resources/strings.dart';
import 'package:placement/services/api_models/fetchService.dart';

class AuthService {
  FetchService _fetchService;
  static final  AuthService _auth = AuthService.internal();

  factory AuthService() => _auth;
  

  AuthService.internal() {
    initState();
  }

  void initState() { 
    _openEncryptedBox();
  }
  var _box;
  Future<int> signInWithEmailPassword(Map<String,String> data) async {
    var jsonData;
    try{
      var res = await http.post(
        EndPoints.HOST+EndPoints.LOGIN,
        body: data
      );
      if(res.statusCode == 200) {
        jsonData = json.decode(res.body);
        _encrypt(jsonData["access"], jsonData["refresh"]);
        return 0;
      }
      return null;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> refreshToken() async {
    var _jsonData;
    String _refresh = _box.get('refresh');
    try{
      var _res = await http.post(
        EndPoints.HOST + EndPoints.REFRESH,
        body: {'refresh' : _refresh},
      );
      if(_res.statusCode == 200) { 
        _jsonData = json.decode(_res.body);
        _encryptToken(_jsonData['access']);
      }
    } catch(e) {

    }
  }

  bool authStateListener() {
    return !(_box.get('access', defaultValue: '') == '');
  }

  dynamic logOut() {
    _box.delete(Strings.AUTH_BOX);
    return "Logged Out";
  }

  _encrypt(String access, String refresh) {
    _box.put('access', access);
    _box.put('refresh', refresh);
  }

  fetchHeaderProvider(String endpoint) {
    return {
      'Authorization' : 'Bearer ' + _box.get('access')
    };
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