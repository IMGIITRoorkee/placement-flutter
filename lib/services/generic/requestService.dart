import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:placement/services/auth/auth_service.dart';
import 'package:placement/shared/debugLog.dart';

/// Supplies the headers (auth token) for a request to [endpoint]. Injectable
/// so tests can exercise the service without a signed-in session.
typedef HeaderProvider = Future<Map<String, String>> Function(String endpoint);

class RequestService {
  RequestService({http.Client? client, HeaderProvider? headerProvider})
      : _client = client ?? http.Client(),
        _headerProvider = headerProvider ?? AuthService().fetchHeaderProvider;

  final http.Client _client;
  final HeaderProvider _headerProvider;

  Future makeGetRequest(String endpoint) async {
    final Map<String, String> _headers = await _headerProvider(endpoint);
    try {
      var res = await _client.get(Uri.parse(endpoint), headers: _headers);
      if (res.statusCode == 200) {
        return json.decode(res.body);
      }
      return -1;
    } catch (e) {
      debugLog("GET $endpoint failed: ${e.toString()}");
      return -2;
    }
  }

  /// Returns the raw response so callers can branch on the status code and
  /// read the server's message.
  /// Returns null when the request could not be made at all.
  Future<http.Response?> makePostRequest(
      String endpoint, Map<String, dynamic> data) async {
    try {
      return await _client.post(Uri.parse(endpoint),
          body: data, headers: await _headerProvider(endpoint));
    } catch (e) {
      debugLog("POST $endpoint failed: ${e.toString()}");
      return null;
    }
  }
}
