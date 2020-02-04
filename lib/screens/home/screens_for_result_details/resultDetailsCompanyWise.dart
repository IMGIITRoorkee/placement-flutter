import 'package:flutter/material.dart';
import 'package:placement/models/companyWiseStudentModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/loadingPage.dart';

class ResultDetailsCompanyWise extends StatefulWidget {
  final String args;
  ResultDetailsCompanyWise({Key key, this.args}) : super(key: key);

  @override
  _ResultDetailsCompanyWiseState createState() => _ResultDetailsCompanyWiseState();
}

class _ResultDetailsCompanyWiseState extends State<ResultDetailsCompanyWise> {
  
  var _fetch;

  @override
  void initState() {
    super.initState();
    _fetch = FetchService();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text("Company Results"),
         ),
         body: _companyResults(context),
       ),
    );
  }

  Widget _companyResults(BuildContext context) {
    return FutureBuilder(
      future: _futureOfResults(context),
      builder: (context, snapshot) {
        if(snapshot.data == null) {
          return LoadingPage();
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          shrinkWrap: true,
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
                  snapshot.data[index].studentBranchName,
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

  Future<List<CompantWiseStudentModel>> _futureOfResults(BuildContext context) async {
    List<CompantWiseStudentModel> _results = [];
    var _data = await _fetch.fetchDataService(
      EndPoints.RESULTS_HOST + widget.args
    );
    for(var r in _data) {
      _results.add(CompantWiseStudentModel.fromJson(r));
    }
    return _results;
  }
}