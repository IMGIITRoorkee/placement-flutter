import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:placement/resources/strings.dart';

class FetchService {

  static final  FetchService _fetchService = FetchService.internal();

  factory FetchService() => _fetchService;

  FetchService.internal() {
    initState();
  }

  void initState() { 
    _openEncryptedBox();
  }
  var _box;

  Future<dynamic>  fetchDataService(String endPoint) async {
    String _jsonData;
    Map< String, String> _headers = {
      'Authorization' : 'Bearer ' + _box.get('access', defaultValue: '') 
    };
    try {
      var res = await http.get(
        endPoint, 
        headers: _headers); 
      if(res.statusCode == 200) {
        return json.decode(res.body);
      }
      return null;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  _openEncryptedBox() async {
      await Hive.initFlutter();
      await Hive.openBox(Strings.AUTH_BOX);
      _box = Hive.box(Strings.AUTH_BOX);
  }
}