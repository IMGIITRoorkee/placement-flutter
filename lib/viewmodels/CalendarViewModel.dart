import '../locator.dart';
import '../models/calendarEventModel.dart';
import '../services/generic/calendarService.dart';
import '../shared/debugLog.dart';
import 'BaseViewModel.dart';

class CalendarViewModel extends BaseViewModel {
  // CalendarController _calendarController = CalendarController();
  CalendarService _calendarService = locator<CalendarService>();
  List<CalendarEventModel> _events = [];
  List<CalendarEventModel> _upcomingEvents = [];
  List<CalendarEventModel> _selectedEvents = [];
  Map<DateTime, List<CalendarEventModel>> _eventMap = {};
  Map<DateTime, List<CalendarEventModel>> get eventMap => _eventMap;
  bool _displayUpcoming = true;
  bool get displayUpcoming => _displayUpcoming;

  // CalendarController get calendarController => _calendarController;
  List<CalendarEventModel> get displayEvents => (_displayUpcoming)
      ? _upcomingEvents
      : _sortedCalendarModel(_selectedEvents);

  List<CalendarEventModel> _sortedCalendarModel(
      List<CalendarEventModel> unsorted) {
    unsorted.sort((a, b) {
      DateTime aDate = DateTime.parse(a.dateTime);
      DateTime bDate = DateTime.parse(b.dateTime);
      return aDate.compareTo(bDate);
    });
    return unsorted;
  }

  Future<void> populateCalendar() async {
    setLoading();
    _events = await _calendarService.fetchEvents();
    if (_events.length > 0) {
      DateTime today = DateTime.now();
      for (var item in _events) {
        DateTime eveDay;
        try {
          eveDay = DateTime.parse(item.dateTime);
        } catch (e) {
          debugLog(e);
          continue;
        }
        DateTime createDay = DateTime(eveDay.year, eveDay.month, eveDay.day);
        
        _eventMap.putIfAbsent(createDay, () => []).add(item);
        
        if (today.isBefore(eveDay)) _upcomingEvents.add(item);
      }
      _upcomingEvents = _sortedCalendarModel(_upcomingEvents);
    }
    setIdle();
  }

  void onSelect(List<CalendarEventModel>? _seEvents) {
    if (_seEvents != null && _seEvents.isNotEmpty) {
      _selectedEvents = _seEvents;
      _displayUpcoming = false;
    } else {
      _displayUpcoming = true;
    }
    reload();
  }
}
