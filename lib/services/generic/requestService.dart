import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:placement/services/auth/auth_service.dart';
import 'package:placement/shared/debugLog.dart';

class RequestService {
  AuthService _auth = AuthService();

  Future makeGetRequest(String endpoint) async {
    dynamic _headers = await _auth.fetchHeaderProvider(endpoint);
    try {
      var res = await http.get(Uri.parse(endpoint), headers: _headers);
      if (res.statusCode == 200) {
        return json.decode(res.body);
      }
      return -1;
    } catch (e) {
      debugLog("GET $endpoint failed: ${e.toString()}");
      return -2;
    }
  }

  Future makePostRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      var res = await http.post(Uri.parse(endpoint),
          body: data, headers: await _auth.fetchHeaderProvider(endpoint));
      if (res.statusCode == 200) {
        return json.decode(res.body);
      }
      return -1;
    } catch (e) {
      debugLog("POST $endpoint failed: ${e.toString()}");
      return -2;
    }
  }
}
