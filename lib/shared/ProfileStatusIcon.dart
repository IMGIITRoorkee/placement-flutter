import 'package:flutter/material.dart';

import '../models/profilesModel.dart';
import '../resources/R.dart';
import '../screens/home/screens_for_apply/bottomModalApplySheet.dart';
import 'debugLog.dart';

class ProfileStatusIcon extends StatelessWidget {
  final String status;
  final ProfilesModel profile;
  final dynamic model;
  const ProfileStatusIcon({
    super.key,
    required this.status,
    required this.profile,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'branch_not_eligible':
        return IconButton(
          icon: Icon(
            Icons.highlight_off,
            color: Colors.red,
          ),
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => AlertDialog(
                      content:
                          Text("This Company is incompatible with you branch"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
          },
        );
      case 'expired':
        return IconButton(
          icon: Icon(
            Icons.highlight_off,
            color: Colors.red,
          ),
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => AlertDialog(
                      content:
                          Text("This Deadline for application has expired"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
          },
        );
      case 'open':
        return IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.green,
          ),
          onPressed: () async {
            bool? _didApply = await showModalBottomSheet<bool>(
                context: context,
                builder: (context) => BottomModalApplySheet(profile: profile));
              if (_didApply == true){
                debugLog("APPLIED!!");
                model.refresh();
                model.refreshDetails();
              }
          },
        );
      case 'withdrawable':
        return IconButton(
          icon: Icon(
            Icons.undo,
            color: R.primaryCol,
          ),
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => AlertDialog(
                      content: Text(
                          "Do you wish to withdraw your resume from this Company?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Sure"),
                          onPressed: () async {
                            await model
                                .deleteApplication(profile.application.id);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          },
        );
      case 'locked':
        return IconButton(
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => AlertDialog(
                      content: Text("This Application has been locked"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
          },
        );
      default:
        return Icon(Icons.signal_cellular_connected_no_internet_4_bar);
    }
  }
}
