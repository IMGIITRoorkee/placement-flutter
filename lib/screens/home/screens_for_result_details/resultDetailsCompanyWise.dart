import 'package:flutter/material.dart';
import 'package:placement/models/companyWiseStudentModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/loadingPage.dart';

class ResultDetailsCompanyWise extends StatefulWidget {
  final Map<String, dynamic> args;
  ResultDetailsCompanyWise({Key key, this.args}) : super(key: key);

  @override
  _ResultDetailsCompanyWiseState createState() =>
      _ResultDetailsCompanyWiseState();
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
        if (snapshot.data == null) {
          return LoadingPage();
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 1),
              elevation: 0.2,
              child: ListTile(
                title: Text(
                  snapshot.data[index].studentName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        snapshot.data[index].studentBranchName,
                        style: TextStyle(height: 1.6),
                      ),
                      Text(
                        "Accepted: " + snapshot.data[index].hasAccepted,
                        style: TextStyle(height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<CompantWiseStudentModel>> _futureOfResults(
      BuildContext context) async {
    List<CompantWiseStudentModel> _results = [];
    var _data = await _fetch
        .fetchDataService(EndPoints.RESULTS_HOST + widget.args['url']);
    for (var r in _data) {
      _results.add(CompantWiseStudentModel.fromJson(r));
    }
    if (widget.args['sort'] == 1) {
      _results.sort((a, b) => a.studentName.compareTo(b.studentName));
    }
    return _results;
  }
}
