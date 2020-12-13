import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:placement/enums/ViewStateEnum.dart';
import 'package:placement/models/calendarEventModel.dart';
import 'package:placement/resources/R.dart';
import 'package:placement/shared/hexColor.dart';
import 'package:placement/shared/loadingPage.dart';
import 'package:placement/viewmodels/CalendarViewModel.dart';
import 'package:placement/views/baseView.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatelessWidget {
  final Map<String, dynamic> args;
  const CalendarView({Key key,this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return BaseView<CalendarViewModel>(
      onModelReady: (model) {
        model.populateCalendar();
      },
      builder: (context, model, child) => calendarScaffold(context, model, _width),
    );
  }

  Widget calendarScaffold(BuildContext context, CalendarViewModel model, double _width) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        centerTitle: true,
      ),
      body: _calendarBody(context, model, _width),
    );
  }

  Widget _calendarBody(BuildContext context, CalendarViewModel model, double _width) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TableCalendar(
            events: model.eventMap,
            calendarController: model.calendarController,
            onDaySelected: (day, events) {
              model.onSelect(events);
              //List<CalendarEventModel> x = events;
              //print("FUKIN EVENTS"+events.toString()+" len "+events.length.toString());
            },
            calendarStyle: CalendarStyle(
              todayColor: Colors.orange,
              selectedColor: Theme.of(context).primaryColor,
            ),
            headerStyle: HeaderStyle(
              formatButtonShowsNext: false,
            ),
          ),
          SizedBox(height: 20,),
          _eventsDisplay(context, model, _width),
        ],
      ),
    );
  }

  Widget _eventsDisplay(BuildContext context, CalendarViewModel model, double _width) {
    if(model.isBusy) return LoadingPage();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        (model.displayUpcoming) ? 
        Container(
          width: _width,
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
            child: Text(
              'Upcoming Events',
              style: TextStyle(
                color: R.textColPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),
        ) :
        Container(),
        _eventList(context, model),
      ],
    );
  }

  Widget _eventList(BuildContext context, CalendarViewModel model) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: model.displayEvents.length,
      itemBuilder: (context, index) {
        CalendarEventModel item = model.displayEvents[index];
        DateTime dateObject = DateTime.parse(item.dateTime);
        var date = Jiffy(dateObject);
        String col = model.displayEvents[index].color;
        return Card(
            margin: EdgeInsets.only(bottom: 1),
            elevation: 0.3,
            child: ListTile(
            title: Row(
              children: <Widget>[
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: (col == null || col == "") ? R.primaryCol : HexColor(col),
                    shape: BoxShape.circle
                  ),
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    item.title + ",  " + item.description,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      fontSize: 15
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Container(
              margin: EdgeInsets.fromLTRB(20, 3, 0, 0),
              child: Text(date.Hm.toString() + ", " + date.MMMMd),
            ),
          ),
        );
      },
    );
  }
}