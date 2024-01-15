import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            elevation: 1,
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 1),
            child: ListTile(
              title: Text(
                "Notification " + index.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("item " + index.toString()),
            ),
          );
        },
      ),
    );
  }
}
