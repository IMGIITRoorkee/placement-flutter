import 'package:flutter/material.dart';

import '../shared/ErrorWidget.dart';
import '../shared/loadingPage.dart';
import '../viewmodels/ResultsBranchWiseViewModel.dart';
import 'baseView.dart';

class ResultsBranchWiseView extends StatefulWidget {
  final int yearSelector, internSwitch, sortSwitch;

  const ResultsBranchWiseView({
    super.key,
    required this.yearSelector,
    required this.internSwitch,
    required this.sortSwitch,
  });

  @override
  State<ResultsBranchWiseView> createState() => _ResultsBranchWiseViewState();
}

class _ResultsBranchWiseViewState extends State<ResultsBranchWiseView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ResultsBranchWiseViewModel>(
      onModelReady: (model) {
        model.setResultFilter(
            widget.yearSelector, widget.internSwitch, widget.sortSwitch);
      },
      builder: (context, model, child) => _resultDisplay(context, model),
    );
  }

  Widget _resultDisplay(BuildContext context, ResultsBranchWiseViewModel model) {
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
      return Center(
        child: LoadingPage(),
      );
    }
    final branchResults = model.branchResults;
    if (branchResults == null) {
      return ErrorWidgetWithRefreshCallback(onRefresh: model.refreshResults);
    }

    final filtered = _query.isEmpty
        ? branchResults
        : branchResults
            .where((r) =>
                r.studentBranchName.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Column(
      children: [
        _searchBar(),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(branchResults.isEmpty
                      ? "No Results Found"
                      : "No matching branches"),
                )
              : RefreshIndicator(
                  onRefresh: model.refreshResults,
                  child: ListView.builder(
                    itemCount: filtered.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final result = filtered[index];
                      return Card(
                        elevation: 0.3,
                        margin: const EdgeInsets.only(bottom: 1),
                        child: ListTile(
                          title: Text(
                            result.studentBranchName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Degree: ${result.studentDegree}",
                                style: const TextStyle(height: 1.85),
                              ),
                              Text(
                                "Selected: ${result.selected}",
                                style: const TextStyle(height: 1.85),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/result_details_branchwise',
                              arguments: {
                                'url': result.studentDetails,
                                'sort': widget.sortSwitch,
                              },
                            );
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
          hintText: 'Search by branch',
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
