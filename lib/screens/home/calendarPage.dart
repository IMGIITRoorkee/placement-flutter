import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
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
            calendarController: _calendarController,
            calendarStyle: CalendarStyle(
              todayColor: Colors.orange,
              selectedColor: Theme.of(context).primaryColor,
            ),
            headerStyle: HeaderStyle(
              formatButtonShowsNext: false,
            ),
          ),
        ],
      ),
    );
  }
}