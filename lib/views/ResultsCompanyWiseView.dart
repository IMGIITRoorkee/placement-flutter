import 'package:flutter/material.dart';
import 'package:placement/resources/R.dart';
import 'package:placement/shared/loadingPage.dart';
import 'package:placement/viewmodels/ResultsCompanyWiseViewModel.dart';
import 'package:placement/views/baseView.dart';

class ResultsCompanyWiseView extends StatelessWidget {
  final int yearSelector, internSwitch, sortSwitch;
  const ResultsCompanyWiseView(
      {Key? key,
      required this.yearSelector,
      required this.internSwitch,
      required this.sortSwitch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ResultsCompanyWiseViewModel>(
      onModelReady: (model) {
        model.setResultFilter(yearSelector, internSwitch, sortSwitch);
      },
      builder: (context, model, child) => _resultDisplay(context, model),
    );
  }

  Widget _resultDisplay(
      BuildContext context, ResultsCompanyWiseViewModel model) {
    bool changed = (model.yearIndex != yearSelector) ||
        (model.internSwitch != internSwitch) ||
        (model.sortSwitch != sortSwitch);
    if (changed) model.setResultFilter(yearSelector, internSwitch, sortSwitch);
    return (changed)
        ? Center(
            child: LoadingPage(),
          )
        : (model.companyResults == null)
            ? Center(
                child: Text("No Results Found"),
              )
            : RefreshIndicator(
                onRefresh: model.refreshResults,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  itemCount: model.companyResults!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 1),
                      elevation: 0.3,
                      child: ListTile(
                        title: Text(
                          model.companyResults![index].companyName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              fontSize: 15),
                        ),
                        subtitle: Wrap(
                          children: <Widget>[
                            Text(
                              "Selected: ",
                              style: TextStyle(height: 1.85),
                            ),
                            Text(
                              model.companyResults![index].selected,
                              style: TextStyle(
                                  height: 1.85,
                                  color: R.primaryCol,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              '/result_details_companywise',
                              arguments: {
                                'url': model.companyResults![index].detail,
                                'sort': model.sortSwitch
                              });
                        },
                      ),
                    );
                  },
                ),
              );
  }
}
