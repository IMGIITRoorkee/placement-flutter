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

class _ResultDetailsCompanyWiseState extends State<ResultDetailsCompanyWise>
    with SingleTickerProviderStateMixin {
  var _fetch;
  List<CompantWiseStudentModel> _results;
  List<CompantWiseStudentModel> _resultsBackup;
  AnimationController animationController;
  Animation<double> animation;
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    _fetch = FetchService();
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
        } else if (overlayEntry.mounted) {
          await Future.delayed(Duration(milliseconds: 10)).whenComplete(
            () => animationController.reverse(),
          );
          overlayEntry.remove();
          return false;
        } else {
          return true;
        }
      },
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Company Results"),
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
          body: _companyResults(context),
        ),
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
                    overlayEntry.remove();
                  },
                ),
                title: TextField(
                  maxLines: 1,
                  cursorColor: Colors.white.withOpacity(0.75),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: _companyResultsFiltered,
                  decoration: InputDecoration(
                    hintText: "Search Name...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.75),
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
    overlayState.insert(overlayEntry);
    animationController.forward();
  }

  Widget _companyResults(BuildContext context) {
    return FutureBuilder(
      future: _futureOfResults(context),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return LoadingPage();
        }
        if (_results.isEmpty) {
          return Center(child: Text("Looks there's no one with that name :("));
        }

        return ListView.builder(
          itemCount: _results.length,
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 1),
              elevation: 0.2,
              child: ListTile(
                title: Text(
                  _results[index].studentName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _results[index].studentBranchName,
                        style: TextStyle(height: 1.6),
                      ),
                      Text(
                        "Accepted: " + _results[index].hasAccepted,
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

  void _companyResultsFiltered(String keyword) {
    setState(() {
      if (keyword == "") {
        _results = _resultsBackup;
      } else {
        _results = _resultsBackup
            .where((element) => element.studentName.contains(keyword))
            .toList();
      }
    });
  }

  Future<String> _futureOfResults(BuildContext context) async {
    if (_results != null && _results.length >= 0) return "Success!";

    List<CompantWiseStudentModel> _studentResults = [];
    var _data = await _fetch
        .fetchDataService(EndPoints.RESULTS_HOST + widget.args['url']);
    for (var r in _data) {
      _studentResults.add(CompantWiseStudentModel.fromJson(r));
    }
    if (widget.args['sort'] == 1) {
      _studentResults.sort((a, b) => a.studentName.compareTo(b.studentName));
    }
    _results = _studentResults;
    _resultsBackup = _results;

    return "Success!";
  }
}
