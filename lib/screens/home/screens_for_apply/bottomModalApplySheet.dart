import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../locator.dart';
import "../../../models/resumeModel.dart";
import '../../../resources/endpoints.dart';
import '../../../services/api_models/fetchService.dart';
import '../../../services/generic/requestService.dart';
import '../../../shared/debugLog.dart';
import '../../../shared/loadingPage.dart';

class BottomModalApplySheet extends StatefulWidget {
  BottomModalApplySheet({super.key, required this.profile});
  final dynamic profile;

  @override
  _BottomModalApplySheetState createState() => _BottomModalApplySheetState();
}

class _BottomModalApplySheetState extends State<BottomModalApplySheet> {
  late dynamic profile;
  var _fetch;
  late RequestService _requestService;
  late List<ResumeModel> _resumeList;
  late Future<dynamic> _resumeFuture;

  @override
  void initState() {
    profile = widget.profile;
    _fetch = FetchService();
    _requestService = locator<RequestService>();
    _resumeList = [];
    _resumeFuture = _giveAppliedResumeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: _resumeFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return SizedBox(
            height: 200,
            child: LoadingPage(),
          );
        }
        return _listOfResume(context, _width, snapshot);
      },
    );
  }

  Widget _listOfResume(
      BuildContext context, double _width, AsyncSnapshot snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length, //snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              children: <Widget>[
                _headerWidget(index),
                (snapshot.data[index].isVerified)
                    ? ListTile(
                        title: Text(snapshot.data[index].title),
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              content: Text(
                                "Do you wish to apply using this resume?",
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.blue,
                                    ),
                                  ),
                                  child: Text("Sure"),
                                  onPressed: () async {
                                    Fluttertoast.showToast(
                                        msg: "Processing...",
                                        toastLength: Toast.LENGTH_LONG);
                                    final _apply = await _requestService
                                        .makePostRequest(
                                            EndPoints.HOST +
                                                EndPoints.APPLICATIONS,
                                            {
                                          "profile":
                                              profile.profileId.toString(),
                                          "resume":
                                              snapshot.data[index].id.toString()
                                          //"cover_letter": null
                                        });
                                    if (!mounted) return;
                                    Navigator.of(context).pop();
                                    if (_isSuccess(_apply)) {
                                      // return true to reload parent page
                                      Navigator.of(context).pop(true);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: _errorMessage(_apply),
                                          textColor: Colors.red,
                                          toastLength: Toast.LENGTH_LONG);
                                      Navigator.of(context).pop(false);
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// The applications endpoint replies 201 on a successful application, so
  /// anything in the 2xx range counts as success.
  bool _isSuccess(http.Response? res) =>
      res != null && res.statusCode >= 200 && res.statusCode < 300;

  String _errorMessage(http.Response? res) {
    if (res == null) {
      return "An error occurred. Please check your connection.";
    }
    try {
      final _body = json.decode(res.body);
      if (_body is Map && _body["error"] != null) {
        return _body["error"].toString();
      }
    } catch (e) {
      debugLog("Could not parse apply error body: ${e.toString()}");
    }
    return "An error occurred. Please try again.";
  }

  Widget _headerWidget(int index) {
    if (index == 0) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Text(
          "Choose the resume you wish to apply with: ",
          style: TextStyle(color: Colors.black54),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Future<dynamic> _giveAppliedResumeList() async {
    var _data = await _fetch
        .fetchDataService(EndPoints.HOST + EndPoints.CANDIDATE_RESUME_LIST);
    for (var r in _data) {
      _resumeList.add(ResumeModel.fromJson(r));
    }
    return _resumeList;
  }
}
