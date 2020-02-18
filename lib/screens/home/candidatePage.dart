import 'package:flutter/material.dart';
import 'package:placement/models/candidateModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/resources/fetchedResources.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/loadingPage.dart';

class CandidatePage extends StatefulWidget {
  CandidatePage({Key key}) : super(key: key);

  @override
  _CandidatePageState createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {

    var _fetch;
    var _fetchedResources;

  @override
  void initState() {
    super.initState();
    _fetch  = FetchService();
    _fetchedResources = FetchedResources();
  }
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return _candidateProfile(context, _width);
  }

  Widget _candidateProfile(BuildContext context, double _width) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: _giveCandidate(),
          builder: (context,snapshot) {
            if(snapshot.data == null) {
              return LoadingPage();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.account_circle,
                              size: 60,
                              color: Colors.deepPurpleAccent,
                              ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            snapshot.data.candidateName,
                            style: TextStyle(
                              fontSize: 30
                            ),  
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: _width*0.75,
                  child: Container(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        snapshot.data.departmentName,
                        style: TextStyle(
                          color: Colors.black54 
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        snapshot.data.degreeName,
                        style: TextStyle(
                          color: Colors.black54 
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        children: <Widget>[
                          Text(
                            "Internship Status: ",
                            style: TextStyle(
                              fontSize: 17
                            ),
                          ),
                          Text(
                            snapshot.data.internshipStatus,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  )
                ),
                Expanded(
                  flex: 4,
                  child: Container(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<CandidateModel> _giveCandidate() async {
    if(!_fetchedResources.candidateProfile['initialised']) {
      var _data = await _fetch.fetchDataService(EndPoints.HOST+EndPoints.CANDIDATE);
      var _candidate = CandidateModel.fromJson(_data);
      _fetchedResources.setCandidateProfile(_candidate);
      return _candidate;
    } else {
      return _fetchedResources.candidateProfile['data'];
    }
  }
}