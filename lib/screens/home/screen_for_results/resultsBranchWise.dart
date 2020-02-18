import 'package:flutter/material.dart';
import 'package:placement/models/branchConciseModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/resources/fetchedResources.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/dataProvider.dart';
import 'package:placement/shared/loadingPage.dart';
import 'package:provider/provider.dart';

class ResultsBranchWise extends StatefulWidget {
  int yearSelectionVariable;
  ResultsBranchWise({Key key,this.yearSelectionVariable}) : super(key: key);

  @override
  _ResultsBranchWiseState createState() => _ResultsBranchWiseState();
}

class _ResultsBranchWiseState extends State<ResultsBranchWise> {

  var _fetch;
  var _fetchedResources;
  List<BranchConciseModel> _results = [];

  @override
  void initState() {
    super.initState();
    _fetch = FetchService();
    _fetchedResources = FetchedResources();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context,data,child) {
        return Container(
          child: _resultDisplay(context,data.yearSelector)
        );
      },
    );
  }

  Widget _resultDisplay(BuildContext context,int yearSelector) {
    return FutureBuilder(
      future: _futureOfResults(context, yearSelector),
      builder: (context, snapshot) {
        if(snapshot.data == null) {
          return LoadingPage();
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 1,top: 0),
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

  Future<List<BranchConciseModel>> _futureOfResults(BuildContext context, int yearSelector) async {
    if (!_fetchedResources.resultsBranchWise['initialised']) {
      var _data = await _fetch.fetchDataService(
        EndPoints.RESULTS_HOST + EndPoints.YEAR['y'] + EndPoints.RESULTS_BRANCH[yearSelector] + EndPoints.WITH_INDEX
      );
      for (var r in _data) {
        _results.add(BranchConciseModel.fromJson(r));
      }
      _fetchedResources.setResultsBranchWise(_results);
      return _results;
    } else {
      return _fetchedResources.resultsBranchWise['data'];
    }
  }
}