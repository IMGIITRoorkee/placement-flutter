import 'dart:convert';

import 'package:placement/locator.dart';
import 'package:placement/models/acknowledgementModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/generic/requestService.dart';
import 'package:placement/services/routing/navigationService.dart';
import 'package:placement/shared/debugLog.dart';

enum AcknowledgementResult {
  /// Accepted, or no season is open so there was nothing to accept.
  accepted,

  /// The user is not an active student.
  forbidden,

  /// The request failed or the server answered something unexpected.
  failed,
}

class AcknowledgementService {
  static const String ROUTE = '/acknowledgement';

  RequestService get _requestService => locator<RequestService>();

  bool _screenOpen = false;

  /// Returns the current state, or null when it could not be fetched.
  Future<AcknowledgementModel?> fetchState() async {
    var res = await _requestService.makeJsonRequest(
        'GET', EndPoints.HOST + EndPoints.ACKNOWLEDGEMENT,
        timeout: const Duration(seconds: 10));
    if (res == null || res.statusCode != 200) return null;
    try {
      return AcknowledgementModel.fromJson(json.decode(res.body));
    } catch (e) {
      debugLog("Acknowledgement state could not be read: $e");
      return null;
    }
  }

  Future<AcknowledgementResult> accept() async {
    var res = await _requestService.makeJsonRequest(
        'POST', EndPoints.HOST + EndPoints.ACKNOWLEDGEMENT,
        body: {'acknowledged': true});
    if (res == null) return AcknowledgementResult.failed;
    if (res.statusCode == 200) {
      try {
        var state = AcknowledgementModel.fromJson(json.decode(res.body));
        if (!state.needsAcknowledgement) return AcknowledgementResult.accepted;
      } catch (_) {}
      return AcknowledgementResult.failed;
    }
    if (res.statusCode == 400 &&
        errorFromBody(res.body) == 'No season is open for you') {
      return AcknowledgementResult.accepted;
    }
    if (res.statusCode == 403) return AcknowledgementResult.forbidden;
    return AcknowledgementResult.failed;
  }

  /// Called by the acknowledgement screen so a burst of gated responses
  /// opens it only once.
  void setScreenOpen(bool open) => _screenOpen = open;

  /// Opens the acknowledgement screen when [statusCode] and [body] are the
  /// gate's 403, which happens when a season opens while the app is running.
  void checkResponse(int statusCode, String body) {
    if (_screenOpen || !isAcknowledgementRequired(statusCode, body)) return;
    var navigator = locator<NavigationService>().navigatorKey.currentState;
    if (navigator == null) return;
    _screenOpen = true;
    navigator.pushNamedAndRemoveUntil(ROUTE, (_) => false);
  }
}
