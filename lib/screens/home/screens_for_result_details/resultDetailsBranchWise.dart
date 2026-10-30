import 'package:flutter/material.dart';

import '../../../models/branchWiseStudentModel.dart';
import '../../../resources/endpoints.dart';
import '../../../services/api_models/fetchService.dart';
import '../../../shared/ErrorWidget.dart';
import '../../../shared/loadingPage.dart';

class ResultDetailsBranchWise extends StatefulWidget {
  final dynamic args;
  ResultDetailsBranchWise({super.key, required this.args});

  @override
  _ResultDetailsBranchWiseState createState() =>
      _ResultDetailsBranchWiseState();
}

class _ResultDetailsBranchWiseState extends State<ResultDetailsBranchWise>
    with SingleTickerProviderStateMixin {
  var _fetch;
  List<BranchWiseStudentModel> _results = [];
  List<BranchWiseStudentModel> _resultsBackup = [];
  late Future<void> _resultsFuture;
  late AnimationController animationController;
  late Animation<double> animation;
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    _fetch = FetchService();
    _resultsFuture = _fetchResults();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurveTween(curve: Curves.fastOutSlowIn).animate(
      animationController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (overlayEntry == null) {
          return true;
        } else if (overlayEntry!.mounted) {
          await Future.delayed(Duration(milliseconds: 10)).whenComplete(
            () => animationController.reverse(),
          );
          overlayEntry!.remove();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Branch Results"),
          actions: [
            IconButton(
              onPressed: () {
                _showOverlay(context);
              },
              icon: Icon(
                Icons.search_rounded,
              ),
            )
          ],
        ),
        body: _branchResults(context),
      ),
    );
  }

  void _showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 0,
          child: FadeTransition(
            opacity: animation,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: kToolbarHeight + MediaQuery.of(context).viewPadding.top,
              child: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () async {
                    await Future.delayed(Duration(milliseconds: 10))
                        .whenComplete(
                      () => animationController.reverse(),
                    );
                    animationController.reverse();
                    overlayEntry!.remove();
                  },
                ),
                title: TextField(
                  maxLines: 1,
                  cursorColor: const Color(0xBFFFFFFF),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: _branchResultsFiltered,
                  decoration: InputDecoration(
                    hintText: "Search Name...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: const Color(0xBFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    animationController.addListener(() {
      overlayState.setState(() {});
    });
    // inserting overlay entry
    overlayState.insert(overlayEntry!);
    animationController.forward();
  }

  Widget _branchResults(BuildContext context) {
    return FutureBuilder(
      future: _resultsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return LoadingPage();
        }
        if (snapshot.hasError) {
          return ErrorWidgetWithRefreshCallback(onRefresh: _refreshResults);
        }
        if (_results.isEmpty) {
          return Center(child: Text("Looks there's no one with that name :("));
        }
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          itemCount: _results.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 1),
              elevation: 0.2,
              child: ListTile(
                title: Text(
                  _results[index].studentName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _results[index].companyName,
                  style: TextStyle(height: 1.85),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _branchResultsFiltered(String keyword) {
    final lowerCaseKeyword = keyword.toLowerCase();
    setState(() {
      if (keyword == "") {
        _results = _resultsBackup;
      } else {
        _results = _resultsBackup
          .where((element) =>
              element.studentName.toLowerCase().contains(lowerCaseKeyword))
          .toList();
      }
    });
  }

  Future<void> _refreshResults() async {
    setState(() {
      _resultsFuture = _fetchResults();
    });
    await _resultsFuture;
  }

  Future<void> _fetchResults() async {
    List<BranchWiseStudentModel> _studentResults = [];
    var _data = await _fetch
        .fetchDataService(EndPoints.RESULTS_HOST + widget.args['url']);
    if (_data == null || _data == -1) {
      throw Exception('Failed to fetch branch results');
    }
    for (var r in _data) {
      _studentResults.add(BranchWiseStudentModel.fromJson(r));
    }
    if (widget.args['sort'] == 1) {
      _studentResults.sort((a, b) => a.studentName.compareTo(b.studentName));
    }

    setState(() {
      _results = _studentResults;
      _resultsBackup = _results;
    });
  }
}
