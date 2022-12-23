import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    // _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return myCalendar(context);
  }

  Widget myCalendar(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        centerTitle: true,
      ),
      body: _calendarBody(context),
    );
  }

  Widget _calendarBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.now().subtract(
              const Duration(days: 100),
            ),
            lastDay: DateTime.now().add(
              const Duration(days: 100),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonShowsNext: false,
            ),
          ),
          // TableCalendar(
          // calendarController: _calendarController,
          // ),
        ],
      ),
    );
  }
}
