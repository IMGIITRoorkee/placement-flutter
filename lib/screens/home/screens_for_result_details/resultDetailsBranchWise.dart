import 'package:flutter/material.dart';
import 'package:placement/models/branchWiseStudentModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/loadingPage.dart';

class ResultDetailsBranchWise extends StatefulWidget {
  final String args;
  ResultDetailsBranchWise({Key key, this.args}) : super(key: key);

  @override
  _ResultDetailsBranchWiseState createState() => _ResultDetailsBranchWiseState();
}

class _ResultDetailsBranchWiseState extends State<ResultDetailsBranchWise> {
  
  var _fetch;

  @override
  void initState() {
    super.initState();
    _fetch = FetchService();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Branch Results"),
      ),
      body: _branchResults(context),
    );
  }

  Widget _branchResults(BuildContext context) {
    //_futureOfResults(context);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("test"),
    //   ),
    //   body: Container(
    //     color: Colors.red,
    //     height: 200,
    //     width: 200,
    //     child: Text(EndPoints.RESULTS_HOST + widget.args),
    //   ),
    // );
    return FutureBuilder(
      future: _futureOfResults(context),
      builder: (context, snapshot) {
        if(snapshot.data == null) {
          return LoadingPage();
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 1),
              child: ListTile(
                title: Text(
                  snapshot.data[index].studentName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  snapshot.data[index].companyName,
                  style: TextStyle(
                    height: 1.85
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<BranchWiseStudentModel>> _futureOfResults(BuildContext context) async {
    List<BranchWiseStudentModel> _results = [];
    var _data = await _fetch.fetchDataService(
      EndPoints.RESULTS_HOST + widget.args
    );
    for (var r in _data) {
      _results.add(BranchWiseStudentModel.fromJson(r));
    }
    return _results;
  }
}