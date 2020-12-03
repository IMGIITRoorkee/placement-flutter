
import 'package:placement/locator.dart';
import 'package:placement/models/calendarEventModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/generic/requestService.dart';

class CalendarService {
  
  final RequestService _req = locator<RequestService>();


  Future<List<CalendarEventModel>> fetchEvents() async {
    List<CalendarEventModel> _events = [];
    var res = await _req.makeGetRequest(
      EndPoints.HOST + EndPoints.CALENDAR_EVENTS
    );
    if(res != -1 && res != -2) {
      for (var event in res["events"]) {
        _events.add(CalendarEventModel.fromJson(event));
      }
    }
    return _events;
  }
}