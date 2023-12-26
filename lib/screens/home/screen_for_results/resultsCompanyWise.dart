import 'package:flutter/material.dart';
import 'package:placement/models/companyConciseModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/resources/fetchedResources.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/dataProvider.dart';
import 'package:placement/shared/loadingPage.dart';
import 'package:provider/provider.dart';

class ResultsCompanyWise extends StatefulWidget {
  bool resultType;
  ResultsCompanyWise({Key key, this.resultType}) : super(key: key);

  @override
  _ResultsCompanyWiseState createState() => _ResultsCompanyWiseState();
}

class _ResultsCompanyWiseState extends State<ResultsCompanyWise> {
  var _fetch;
  var _fetchedResources;
  List<CompanyConciseModel> _results = [];

  @override
  void initState() {
    super.initState();
    _fetch = FetchService();
    _fetchedResources = FetchedResources();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, data, child) {
        return Container(child: _resultDisplay(context, data.yearSelector));
      },
    );
  }

  Widget _resultDisplay(BuildContext context, int yearSelector) {
    return FutureBuilder(
      future: _futureOfResults(context, yearSelector),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return LoadingPage();
        }
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 1),
              elevation: 0.2,
              child: ListTile(
                title: Text(
                  snapshot.data[index].companyName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Wrap(
                  children: <Widget>[
                    Text(
                      "Selected: ",
                      style: TextStyle(height: 1.85),
                    ),
                    Text(
                      snapshot.data[index].selected,
                      style: TextStyle(
                          height: 1.85,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/result_details_companywise',
                      arguments: snapshot.data[index].detail);
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<List<CompanyConciseModel>> _futureOfResults(
      BuildContext context, int yearSelector) async {
    if (!_fetchedResources.resultsCompanyWise['initialised']) {
      var _data = await _fetch.fetchDataService(EndPoints.RESULTS_HOST +
          EndPoints.RESULTS_COMPANY[0] +
          EndPoints.WITH_INDEX);
      for (var r in _data) {
        _results.add(CompanyConciseModel.fromJson(r));
      }
      _fetchedResources.setResultsCompanyWise(_results);
      return _results;
    } else {
      return _fetchedResources.resultsCompanyWise['data'];
    }
  }
}
