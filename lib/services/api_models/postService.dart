import 'package:http/http.dart' as http;
import 'package:placement/resources/endpoints.dart';

class PostService {

  Future<int> applyPostService(Map<String, dynamic> _data) async {
    try {
      var res = await http.post(
        EndPoints.HOST + EndPoints.APPLICATIONS,
        body: _data
      );
      if (res.statusCode == 200) {
        return 0;
      }
      return 1;
    } catch (e) {
      return 2;
    }
  } 
}