import 'package:flutter/material.dart';
import 'package:placement/models/resumeModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/services/api_models/postService.dart';
import 'package:placement/shared/loadingPage.dart';

class BottomModalApplySheet extends StatefulWidget {
  BottomModalApplySheet({Key key,this.profile}) : super(key: key);
  final profile; 

  @override
  _BottomModalApplySheetState createState() => _BottomModalApplySheetState();
}

class _BottomModalApplySheetState extends State<BottomModalApplySheet> {

  var profile;
  var _fetch;
  PostService _postService;
  List<ResumeModel> _resumeList;
  Future<dynamic> _resumeFuture;

  @override
  void initState() {
    profile = widget.profile;
    _fetch = FetchService();
    _postService = PostService();
    _resumeList = [];
    _resumeFuture = _giveAppliedResumeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Container(
       child: FutureBuilder(
         future: _resumeFuture,
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
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              children: <Widget>[
                _headerWidget(index),
                ListTile(
                  title: Text(snapshot.data[index].title),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AlertDialog(
                        content: Text("Do you wish to apply using this resume?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Sure"),
                            onPressed: () async {
                              int _applyPost = await _postService.applyPostService(
                                {
                                  "profile": profile,
                                  "resume": snapshot.data[index],
                                  "cover_letter": null
                                }
                              );
                              // TODO : handle the response
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _headerWidget(int index) {
    if (index == 0) {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Text(
          "Choose the resume you wish to apply with: ",
          style: TextStyle(color: Colors.black54),
        ),
      );
    }
    return SizedBox();
  }

  Future<dynamic> _giveAppliedResumeList() async {
    var _data = await _fetch.fetchDataService(EndPoints.HOST+EndPoints.CANDIDATE_RESUME_LIST);
    for (var r in _data) {
      _resumeList.add(ResumeModel.fromJson(r));
    }
    return _resumeList;
  }
}