import 'package:flutter/material.dart';
import 'package:placement/models/branchConciseModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/loadingPage.dart';

class ResultsBranchWise extends StatefulWidget {
  bool resultType;
  ResultsBranchWise({Key key,this.resultType}) : super(key: key);

  @override
  _ResultsBranchWiseState createState() => _ResultsBranchWiseState();
}

class _ResultsBranchWiseState extends State<ResultsBranchWise> {

  var _fetch;

  @override
  void initState() {
    super.initState();
    _fetch  = FetchService();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: _resultDisplay(context),
    );
  }

  Widget _resultDisplay(BuildContext context) {
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
                  snapshot.data[index].studentBranchName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),  
                ),
                subtitle: Text(
                  "Degree: " + snapshot.data[index].studentDegree,
                  style: TextStyle(
                    height: 1.85
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/result_details_branchwise',arguments: snapshot.data[index].studentDetails);
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<List<BranchConciseModel>> _futureOfResults(BuildContext context) async {
    List<BranchConciseModel> _results = [];
    var _data = await _fetch.fetchDataService(
      EndPoints.RESULTS_HOST + EndPoints.YEAR['y'] + EndPoints.RESULTS_BRANCH[0] + EndPoints.WITH_INDEX
    );
    for (var r in _data) {
      _results.add(BranchConciseModel.fromJson(r));
    }
    return _results;
  }
}