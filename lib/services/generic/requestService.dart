import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:placement/services/auth/auth_service.dart';

class RequestService {
  AuthService _auth = AuthService();

  Future makeGetRequest(String endpoint) async {
    dynamic _headers = await _auth.fetchHeaderProvider(endpoint);
    print(endpoint);
    print(_headers);
    try {
      var res = await http.get(Uri.parse(endpoint), headers: _headers);
      if (res.statusCode == 200) {
        print("GOT 200");
        print(json.decode(res.body));
        return json.decode(res.body);
      }
      return -1;
    } catch (e) {
      print("REQUEST FAILED");
      print(e.toString());
      return -2;
    }
  }

  Future makePostRequest(String endpoint, Map<String, dynamic> data) async {
    print(endpoint);
    print(data.toString());
    print("GOING TO POST!!!");
    try {
      var res = await http.post(Uri.parse(endpoint),
          body: data, headers: await _auth.fetchHeaderProvider(endpoint));
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        print("GOT 200");
        return json.decode(res.body);
      }
      return -1;
    } catch (e) {
      print(e.toString());
      print("POST REQUEST FAILED");
      return -2;
    }
  }

  Future dioGetRequest(String endpoint, Map<String, dynamic> data) async {
    print(endpoint);
    print(data);
    var dio = Dio();
    dio.options.headers['authorization'] =
        await _auth.fetchHeaderProvider(endpoint);
    try {
      Response res = await dio.get(endpoint, queryParameters: data);
      print(res.statusCode);
      if (res.statusCode == 200) {
        print(res.data);
        return res.data;
      }
      return -1;
    } catch (e) {
      print('REQUEST FAILED!!');
      print(e.toString());
      return -2;
    }
  }
}
