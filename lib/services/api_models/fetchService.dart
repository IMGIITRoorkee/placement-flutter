import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/resources/strings.dart';
import 'package:placement/services/auth/auth_service.dart';

class FetchService {

  static final  FetchService _fetchService = FetchService.internal();
  var _auth;
  factory FetchService() => _fetchService;

  FetchService.internal() {
    initState();
  }

  void initState() { 
    _auth = AuthService();
  }

  Future<dynamic>  fetchDataService(String endPoint) async {
    String _jsonData;
    Map< String, String> _headers = _auth.fetchHeaderProvider(endPoint);
    try {
      var res = await http.get(
        endPoint, 
        headers: _headers);print(res.statusCode);
      if(res.statusCode == 200) {print("inside 200");
        return json.decode(res.body);
      }
      if(res.statusCode == 401 && endPoint != EndPoints.HOST + EndPoints.LOGIN) {
        return fetchDataService(endPoint);
      }
      return -1;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}