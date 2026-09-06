import 'package:flutter/material.dart';

import '../resources/R.dart';
import '../shared/ErrorWidget.dart';
import '../shared/loadingPage.dart';
import '../viewmodels/ResultsCompanyWiseViewModel.dart';
import 'baseView.dart';

class ResultsCompanyWiseView extends StatefulWidget {
  final int yearSelector, internSwitch, sortSwitch;
  const ResultsCompanyWiseView({
    super.key,
    required this.yearSelector,
    required this.internSwitch,
    required this.sortSwitch,
  });

  @override
  State<ResultsCompanyWiseView> createState() => _ResultsCompanyWiseViewState();
}

class _ResultsCompanyWiseViewState extends State<ResultsCompanyWiseView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ResultsCompanyWiseViewModel>(
      onModelReady: (model) {
        model.setResultFilter(
            widget.yearSelector, widget.internSwitch, widget.sortSwitch);
      },
      builder: (context, model, child) => _resultDisplay(context, model),
    );
  }

  Widget _resultDisplay(
      BuildContext context, ResultsCompanyWiseViewModel model) {
    bool filtersHaveChanged = (model.yearIndex != widget.yearSelector) ||
        (model.internSwitch != widget.internSwitch) ||
        (model.sortSwitch != widget.sortSwitch);
    if (filtersHaveChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        model.setResultFilter(
            widget.yearSelector, widget.internSwitch, widget.sortSwitch);
      });
    }

    if (model.isBusy) {
      return Center(child: LoadingPage());
    }
    final companyResults = model.companyResults;
    if (companyResults == null) {
      return ErrorWidgetWithRefreshCallback(onRefresh: model.refreshResults);
    }

    final filtered = _query.isEmpty
        ? companyResults
        : companyResults
            .where((c) =>
                c.companyName.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Column(
      children: [
        _searchBar(),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(companyResults.isEmpty
                      ? "No Results Found"
                      : "No matching companies"),
                )
              : RefreshIndicator(
                  onRefresh: model.refreshResults,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0.3,
                        margin: const EdgeInsets.only(bottom: 1),
                        child: ListTile(
                          title: Text(
                            filtered[index].companyName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                                fontSize: 15),
                          ),
                          subtitle: Wrap(
                            children: <Widget>[
                              const Text(
                                "Selected: ",
                                style: TextStyle(height: 1.85),
                              ),
                              Text(
                                filtered[index].selected,
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
                                  'url': filtered[index].detail,
                                  'sort': model.sortSwitch
                                });
                          },
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by company',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                ),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) => setState(() => _query = value),
      ),
    );
  }
}
