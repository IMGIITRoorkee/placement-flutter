import 'package:http/http.dart' as http;
import 'package:placement/resources/endpoints.dart';

class DeleteService {

  Future<void> deleteApplicationService(int applicationID) async {
    var _deleteResponse = await genericDeleteService(EndPoints.HOST + EndPoints.APPLICATIONS + applicationID.toString());
  }

  Future<dynamic> genericDeleteService(String url) async {
    return await http.delete(url);
  }
}