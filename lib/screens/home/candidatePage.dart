import 'package:flutter/material.dart';
import 'package:placement/models/candidateModel.dart';
import 'package:placement/resources/R.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/resources/fetchedResources.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/services/auth/auth_service.dart';
import 'package:placement/shared/hexColor.dart';
import 'package:placement/shared/loadingPage.dart';

class CandidatePage extends StatefulWidget {
  CandidatePage({Key key}) : super(key: key);

  @override
  _CandidatePageState createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {

    var _fetch;
    var _fetchedResources;
    AuthService _auth;

  @override
  void initState() {
    super.initState();
    _fetch  = FetchService();
    _auth = AuthService();
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
        constraints: BoxConstraints.expand(),
        child: FutureBuilder(
          future: _giveCandidate(),
          builder: (context,snapshot) {
            if(snapshot.data == null) {
              return LoadingPage();
            }
            return _profileBody(context, snapshot.data, _width);
          },
        ),
      ),
    );
  }

  Widget _profileBody(BuildContext context, dynamic model, double _width) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 30,),
          _headerAndIcon(context, model, _width),
          SizedBox(height: 20,),
          _studentInfo(context, model, _width),
          SizedBox(height: 20,),
          _myApplicationsButton(context, model, _width),
          SizedBox(height: 20,),
          _myResumesButton(context, model, _width),
          SizedBox(height: 20,),
          _menu(context, model, _width),
        ],
      ),
    );
  }

  Widget _menu(BuildContext context, dynamic model, double _width) {
    return Container(
      width: _width*0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            leading: Icon(Icons.help_outline),
            title: Text("FAQs",
              style: TextStyle(
                color: R.textColPrimary
              ),
            ),
            onTap: () {
              
            },
          ),
          _divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            leading: Icon(Icons.info),
            title: Text("About Us",
              style: TextStyle(
                color: R.textColPrimary
              ),
            ),
            onTap: () {
              
            },
          ),
          _divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            leading: Icon(Icons.exit_to_app),
            title: Text("Log Out",
              style: TextStyle(
                color: R.textColPrimary
              ),
            ),
            onTap: () async {
              await _auth.logOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/wrapper',(Route<dynamic> route)=>false);
            },
          ),
          _divider(),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: HexColor("#e6e6e6"),
      thickness: 1,
      indent: 10,
      height: 0,
      endIndent: 10,
    );
  }

  Widget _myApplicationsButton(BuildContext context, dynamic model, double _width) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/profileApplied');
      },
      child: _button("My Applications", _width),
    );
  }

  Widget _myResumesButton(BuildContext context, dynamic model, double _width) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/resumes');
      },
      child: _button("My Resumes", _width),
    );
  }

  Widget _button(String heading, double _width) {
    return Container(
      width: _width*0.9,
      decoration: BoxDecoration(
        color: HexColor('#73A1FD').withOpacity(0.1),
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child:Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                heading,
                style: TextStyle(
                  color: HexColor('#878787'),
                  fontSize: 17
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              Icons.arrow_forward_ios,
              color: HexColor("#73A1FD"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _studentInfo(BuildContext context, dynamic model, double _width) {
    return Container(
      width: _width*0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            model.degreeName,
            style: TextStyle(
              color: Colors.black54 
            ),
          ),
          SizedBox(height: 5,),
          Text(
            model.departmentName,
            style: TextStyle(
              color: Colors.black54 
            ),
          ),
          SizedBox(height: 10,),
          _statusRows(model.season + " Status: ", model.internshipStatus),
          SizedBox(height: 5,),
          _statusRows("Pool A Credits: ", model.creditsPoolA.toString()),
          SizedBox(height: 5,),
          _statusRows("Pool B Credits: ", model.creditsPoolB.toString()),
        ],
      ),
    );
  }

  Widget _statusRows(String heading, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          heading,
          style: TextStyle(
            fontSize: 17,
            color: R.textColPrimary
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  Widget _headerAndIcon(BuildContext context, dynamic model, double _width) {
    return Container(
      width: _width*0.9,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
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
          SizedBox(width: 10,),
          Text(
            model.candidateName,
            style: TextStyle(
              fontSize: 30
            ),
          ),
        ],
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