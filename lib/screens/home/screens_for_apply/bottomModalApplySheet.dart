import 'package:flutter/material.dart';
import 'package:placement/models/resumeModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/loadingPage.dart';

class BottomModalApplySheet extends StatefulWidget {
  BottomModalApplySheet({Key key,this.applyId}) : super(key: key);
  final applyId; 

  @override
  _BottomModalApplySheetState createState() => _BottomModalApplySheetState();
}

class _BottomModalApplySheetState extends State<BottomModalApplySheet> {

  var applyId;
  var _fetch;
  List<ResumeModel> _resumeList;

  @override
  void initState() {
    applyId = widget.applyId;
    _fetch = FetchService();
    _resumeList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Container(
       child: FutureBuilder(
         future: _giveAppliedResumeList(context),
         builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              width: _width*0.9,
              height: 200,
              child: LoadingPage(),
            );
          }
          return _listOfResume(context, _width, snapshot);
         },
       ),
    );
  }

  Widget _listOfResume(BuildContext context, double _width, AsyncSnapshot snapshot) {
    return ListView.builder(
    shrinkWrap: true,
    itemCount: snapshot.data.length, //snapshot.data.length,
    itemBuilder: (BuildContext context, int index) {
      return Card(
        child: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.all(7),
                child: Center(child: Text("Resume"),),
              ),
            ),
            Container(
              child: Center(child: Text("Preview"),),
              height: 100,
              width: _width,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
            ),
            SizedBox(height: 5,),
          ],
        ),
      );
    },
  );
  }

  Future<dynamic> _giveAppliedResumeList(BuildContext context) async {
    var _data = await _fetch.fetchDataService(EndPoints.HOST+EndPoints.CANDIDATE_RESUME_LIST);
    print(_data);
    for (var r in _data) {
      _resumeList.add(ResumeModel.fromJson(r));
    }
    return _resumeList;
  }
}