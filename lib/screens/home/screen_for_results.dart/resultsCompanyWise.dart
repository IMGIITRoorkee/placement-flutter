import 'package:flutter/material.dart';
import 'package:placement/models/companyConciseModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/api_models/fetchService.dart';
import 'package:placement/shared/loadingPage.dart';

class ResultsCompanyWise extends StatefulWidget {
  bool resultType;
  ResultsCompanyWise({Key key,this.resultType}) : super(key: key);

  @override
  _ResultsCompanyWiseState createState() => _ResultsCompanyWiseState();
}

class _ResultsCompanyWiseState extends State<ResultsCompanyWise> {

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
                  snapshot.data[index].companyName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),  
                ),
                subtitle: Wrap(
                  children: <Widget>[
                    Text(
                      "Selected: ",
                      style: TextStyle(
                        height: 1.85
                      ),
                    ),
                    Text(
                      snapshot.data[index].selected,
                      style: TextStyle(
                        height: 1.85,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/result_details_companywise',arguments: snapshot.data[index].detail);
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<List<CompanyConciseModel>> _futureOfResults(BuildContext context) async {
    List<CompanyConciseModel> _results = [];
    var _data = await _fetch.fetchDataService(
      EndPoints.RESULTS_HOST + EndPoints.YEAR['y'] + EndPoints.RESULTS_COMPANY[0] + EndPoints.WITH_INDEX
    );
    for (var r in _data) {
      _results.add(CompanyConciseModel.fromJson(r));
    }
    return _results;
  }
}