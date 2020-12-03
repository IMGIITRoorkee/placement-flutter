import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:placement/models/profilesModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/resources/fetchedResources.dart';
import 'package:placement/screens/home/screens_for_apply/bottomModalApplySheet.dart';
import 'package:placement/services/api_models/deleteService.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/loadingPage.dart';

class ProfilesForAllPage extends StatefulWidget {
  ProfilesForAllPage({Key key}) : super(key: key);

  @override
  _ProfilesForAllPageState createState() => _ProfilesForAllPageState();
}

class _ProfilesForAllPageState extends State<ProfilesForAllPage> {

  var _fetch;
  var _fetchedResources;
  var _deleteService;
  List<ProfilesModel> _profiles = [];

  @override
  void initState() {
    super.initState();
    _fetch  = FetchService();
    _fetchedResources = FetchedResources();
    _deleteService = DeleteService();
  }

  @override
  Widget build(BuildContext context) {
    var  _width = MediaQuery.of(context).size.width;
    return Container(
      child: FutureBuilder(
        future: _giveList(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data == null) {
            return LoadingPage();
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            padding: EdgeInsets.all(0),
            itemBuilder: (BuildContext context, int index) {
              String _date =
                snapshot.data[index].applicationDeadline !=null ?
                "Apply before " + Jiffy(snapshot.data[index].applicationDeadline.toString()).yMMMd :
                'Open';
                return Card(
                  margin: EdgeInsets.only(bottom: 1),
                  child: ListTile(
                    title: Text(
                      snapshot.data[index].companyName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.5
                      ),
                    ),
                    subtitle: Text(
                      "Status: " + _date,
                      style: TextStyle(
                        height: 1.85,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed("/profileDetail",arguments: snapshot.data[index]);
                    },
                    trailing: _profileStatusIcon(context,snapshot.data[index].status,snapshot.data[index]),
                  )
                );
            },
          );
        },
      ),
    );
  }

  Widget _profileStatusIcon(BuildContext context,String status,dynamic profile) {
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
          icon: Icon(Icons.next_week, color: Colors.green,),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return BottomModalApplySheet(
                  profile: profile,
                );
              }
            );
          },
        );
        break;
      case 'withdrawable':
        return IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue,),
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
                    onPressed: () {
                      _deleteService.deleteApplicationService(profile.application.id);
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

  Future<List<ProfilesModel>>  _giveList(BuildContext context) async {    
    if (!_fetchedResources.applyForAll['initialised']) {
      var _data = await _fetch.fetchDataService(EndPoints.HOST+EndPoints.PROFILES_ALL);print(_data);
      for(var p in _data) {
        _profiles.add(ProfilesModel.fromJson(p));
      }
      _fetchedResources.setApplyForAll(_profiles);
      return _profiles;
    } else {
      return _fetchedResources.applyForAll['data'];
    }
  }
}