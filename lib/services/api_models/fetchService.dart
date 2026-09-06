import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:placement/locator.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/auth/auth_service.dart';
import 'package:placement/services/routing/navigationService.dart';

class FetchService {
  static final FetchService _fetchService = FetchService.internal();
  var _auth;
  factory FetchService() => _fetchService;

  FetchService.internal() {
    initState();
  }

  void initState() {
    _auth = AuthService();
  }

  Future<dynamic> fetchDataService(String endPoint,
      {bool isRetryAfterRefresh = false}) async {
    // String _jsonData;
    Map<String, String> _headers = await _auth.fetchHeaderProvider(endPoint);
    try {
      var res = await http.get(Uri.parse(endPoint), headers: _headers);
      if (res.statusCode == 200) {
        return json.decode(res.body);
      }
      if (res.statusCode == 401 &&
          endPoint != EndPoints.HOST + EndPoints.LOGIN) {
        if (!isRetryAfterRefresh && await _auth.refreshToken()) {
          return fetchDataService(endPoint, isRetryAfterRefresh: true);
        }
        await _auth.logOut();
        locator<NavigationService>().navigateToWithRemove('/wrapper', {});
        return -1;
      }
      return -1;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
