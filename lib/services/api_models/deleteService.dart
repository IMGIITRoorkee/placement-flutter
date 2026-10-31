import 'package:http/http.dart' as http;

import '../../locator.dart';
import '../../resources/endpoints.dart';
import '../../shared/debugLog.dart';
import '../auth/auth_service.dart';
import '../generic/acknowledgementService.dart';

class DeleteService {
  AuthService _auth = AuthService();

  Future<void> deleteApplicationService(int applicationID) async {
    await genericDeleteService(EndPoints.HOST +
        EndPoints.APPLICATIONS +
        applicationID.toString() +
        '/');
  }

  Future<dynamic> genericDeleteService(String url) async {
    try {
      var res = await http.delete(Uri.parse(url),
          headers: await _auth.fetchHeaderProvider(''));
      debugLog("DELETE $url returned status ${res.statusCode}");
      locator<AcknowledgementService>().checkResponse(res.statusCode, res.body);
    } catch (e) {
      debugLog("DELETE $url failed: $e");
    }
  }
}
