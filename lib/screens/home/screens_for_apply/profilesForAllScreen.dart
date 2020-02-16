import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:placement/models/profilesModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/resources/fetchedResources.dart';
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
  List<ProfilesModel> _profiles = [];

  @override
  void initState() {
    super.initState();
    _fetch  = FetchService();
    _fetchedResources = FetchedResources();
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
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    subtitle: Text(
                      "Status: " + _date,
                      style: TextStyle(
                        height: 1.85,
                      ),
                    ),
                    onTap: () {
                      print("tapped");
                    },
                  )
                );
            },
          );
        },
      ),
    );
  }

  Future<List<ProfilesModel>>  _giveList(BuildContext context) async {    
    if (!_fetchedResources.applyForAll['initialised']) {
      var _data = await _fetch.fetchDataService(EndPoints.HOST+EndPoints.PROFILES_ALL);
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