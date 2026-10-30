import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:placement/locator.dart';
import 'package:placement/services/auth/auth_service.dart';
import 'package:placement/services/generic/acknowledgementService.dart';
import 'package:placement/shared/debugLog.dart';

class RequestService {
  AuthService _auth = AuthService();

  Future makeGetRequest(String endpoint) async {
    dynamic _headers = await _auth.fetchHeaderProvider(endpoint);
    try {
      var res = await http.get(Uri.parse(endpoint), headers: _headers);
      _checkGate(res);
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
      _checkGate(res);
      if (res.statusCode == 200) {
        return json.decode(res.body);
      }
      return -1;
    } catch (e) {
      debugLog("POST $endpoint failed: ${e.toString()}");
      return -2;
    }
  }

  /// Sends [body] as JSON and returns the response whatever its status, for
  /// callers that need the status code. Returns null when the request could
  /// not be made or took longer than [timeout].
  Future<http.Response?> makeJsonRequest(String method, String endpoint,
      {Map<String, dynamic>? body,
      Duration timeout = const Duration(seconds: 30)}) async {
    http.Client _client = http.Client();
    try {
      var req = http.Request(method, Uri.parse(endpoint));
      req.headers.addAll(
          Map<String, String>.from(await _auth.fetchHeaderProvider(endpoint)));
      if (body != null) {
        req.headers['Content-Type'] = 'application/json';
        req.body = json.encode(body);
      }
      var res = await _client
          .send(req)
          .then(http.Response.fromStream)
          .timeout(timeout);
      debugLog("$method $endpoint returned status ${res.statusCode}");
      _checkGate(res);
      return res;
    } catch (e) {
      debugLog("$method $endpoint failed: ${e.toString()}");
      return null;
    } finally {
      _client.close();
    }
  }

  /// Opens the acknowledgement screen if [res] is the gate's 403.
  void _checkGate(http.Response res) {
    locator<AcknowledgementService>().checkResponse(res.statusCode, res.body);
  }
}
