import 'package:http/http.dart' as http;
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/auth/auth_service.dart';

class DeleteService {
  AuthService _auth = AuthService();

  Future<void> deleteApplicationService(int applicationID) async {
    print("HELLO!! im in!! DELETING $applicationID");
    var res = await genericDeleteService(EndPoints.HOST +
        EndPoints.APPLICATIONS +
        applicationID.toString() +
        '/');
  }

  Future<dynamic> genericDeleteService(String url) async {
    try {
      var res = await http.delete(Uri.parse(url),
          headers: await _auth.fetchHeaderProvider(''));
      print(res.statusCode);
      print(res.body);
    } catch (e) {
      print("DELETION FAILED!");
      print(e);
    }
  }
}
