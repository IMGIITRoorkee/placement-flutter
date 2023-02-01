import 'package:flutter/material.dart';
import 'package:placement/shared/loadingPage.dart';
import 'package:placement/viewmodels/ResultsBranchWiseViewModel.dart';
import 'package:placement/views/baseView.dart';

class ResultsBranchWiseView extends StatelessWidget {
  final int yearSelector, internSwitch, sortSwitch;
  const ResultsBranchWiseView(
      {Key key, this.yearSelector, this.internSwitch, this.sortSwitch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ResultsBranchWiseViewModel>(
      onModelReady: (model) {
        model.setResultFilter(yearSelector, internSwitch, sortSwitch);
      },
      builder: (context, model, child) => _resultDisplay(context, model),
    );
  }

  Widget _resultDisplay(
      BuildContext context, ResultsBranchWiseViewModel model) {
    bool changed = (model.yearIndex != yearSelector) ||
        (model.internSwitch != internSwitch) ||
        (model.sortSwitch != sortSwitch);
    if (changed) model.setResultFilter(yearSelector, internSwitch, sortSwitch);
    return (changed)
        ? Center(
            child: LoadingPage(),
          )
        : (model.branchResults == null)
            ? Center(
                child: Text("No Results Found"),
              )
            : RefreshIndicator(
                onRefresh: model.refreshResults,
                child: ListView.builder(
                  itemCount: model.branchResults.length,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0.3,
                      margin: EdgeInsets.only(bottom: 1, top: 0),
                      child: ListTile(
                        title: Text(
                          model.branchResults[index].studentBranchName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              fontSize: 15),
                        ),
                        // subtitle: Text(
                        //   "Degree: " + model.branchResults[index].studentDegree,
                        //   style: TextStyle(height: 1.85),
                        // ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Degree: " +  model.branchResults[index].studentDegree,
                              style: TextStyle(height: 1.85),
                            ),
                            Text(
                              "Selected: " +  model.branchResults[index].selected,
                              style: TextStyle(height: 1.85),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              '/result_details_branchwise',
                              arguments: {
                                'url':
                                    model.branchResults[index].studentDetails,
                                'sort': sortSwitch
                              });
                        },
                      ),
                    );
                  },
                ),
              );
  }
}
