import 'package:flutter/material.dart';
import 'package:placement/resources/R.dart';
import 'package:placement/screens/home/screens_for_apply/bottomModalApplySheet.dart';

class ProfileStatusIcon extends StatelessWidget {
  final String status;
  final dynamic profile;
  final dynamic model;
  const ProfileStatusIcon({Key key, this.status, this.profile, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'branch_not_eligible':
        return IconButton(
          icon: Icon(Icons.highlight_off,color: Colors.red,),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                content: Text("This Company is incompatible with you branch"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ], 
              )
            );
          },
        );
        break;
      case 'expired':
        return IconButton(
          icon: Icon(Icons.highlight_off, color: Colors.red,),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                content: Text("This Deadline for application has expired"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ], 
              )
            );
          },
        );
        break;
      case 'open':
        return IconButton(
          icon: Icon(Icons.send, color: Colors.green,),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return BottomModalApplySheet(
                  profile: profile,
                );
              }
            ).then((value) {
              print("APPLIED!!");
              model.refresh();
            });
          },
        );
        break;
      case 'withdrawable':
        return IconButton(
          icon: Icon(Icons.undo, color: R.primaryCol,),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                content: Text("Do you wish to withdraw your resume from this Company?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Sure"),
                    onPressed: () async {
                      await model.deleteApplication(profile.application.id);
                      Navigator.of(context).pop();
                    },
                  ),
                ], 
              )
            );
          },
        );
        break;
      case 'locked':
        return IconButton(
          icon: Icon(Icons.lock, color: Colors.grey,),
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                content: Text("This Application has been locked"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ], 
              )
            );
          },
        );
        break;
      default:return Icon(Icons.signal_cellular_connected_no_internet_4_bar);
    }
  }
}