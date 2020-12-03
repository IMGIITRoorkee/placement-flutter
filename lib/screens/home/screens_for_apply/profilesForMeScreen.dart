import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:placement/models/profilesModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/resources/fetchedResources.dart';
import 'package:placement/screens/home/screens_for_apply/bottomModalApplySheet.dart';
import 'package:placement/services/api_models/deleteService.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/loadingPage.dart';

class ProfilesForMePage extends StatefulWidget {
  ProfilesForMePage({Key key}) : super(key: key);

  @override
  _ProfilesForMePageState createState() => _ProfilesForMePageState();
}

class _ProfilesForMePageState extends State<ProfilesForMePage> {

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
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: <Widget>[
            _applyList(context),
          ],
        ),
      ),
    );
  }

  Widget _applyList(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _giveList(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data == null) {
            return LoadingPage();
          }
          //return Container(height: 100,width: 100,color: Colors.red,);
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            padding: EdgeInsets.all(5),
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
                    trailing: _profileStatusIcon(context,snapshot.data[index].status,snapshot.data[index])
                  )
                );
            },
          );
        },
      ),
    );
  }


  Widget _profileStatusIcon(BuildContext context,String status, dynamic profile) {
    print("STATUS - $status");
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
          icon: Icon(Icons.undo, color: Colors.green,),
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
                    onPressed: () async {
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
    if (!_fetchedResources.applyForMe['initialised']) {
      var _data = await _fetch.fetchDataService(EndPoints.HOST+EndPoints.PROFILES_ME);
      for(var p in _data) {
        _profiles.add(ProfilesModel.fromJson(p));
      }
      _fetchedResources.setApplyForMe(_profiles);
      return _profiles;
    } else {
      return _fetchedResources.applyForMe['data'];
    }
  }
}