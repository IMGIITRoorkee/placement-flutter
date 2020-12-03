import 'package:flutter/material.dart';
import 'package:placement/resources/R.dart';
import 'package:placement/resources/strings.dart';
import 'package:placement/screens/home/screen_for_results/bottomSheetForm.dart';
import 'package:placement/viewmodels/ResultPageViewModel.dart';
import 'package:placement/views/ResultsBranchWiseView.dart';
import 'package:placement/views/ResultsCompanyWiseView.dart';
import 'package:placement/views/baseView.dart';

class ResultPageView extends StatefulWidget {
  ResultPageView({Key key}) : super(key: key);

  @override
  _ResultPageViewState createState() => _ResultPageViewState();
}

class _ResultPageViewState extends State<ResultPageView> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: 2
    );
    super.initState();
  }

  @override
  void dispose() { 
    _tabController.dispose();
    super.dispose();
  }

  List<Tab> _profileTabs = <Tab>[
    Tab(
      text: Strings.RESULT_TABBAR[0],
    ),
    Tab(
      text: Strings.RESULT_TABBAR[1],
    ),
  ];
  
  @override
  Widget build(BuildContext context) {

    final double _width = MediaQuery.of(context).size.width;

    return BaseView<ResultPageViewModel>(
      onModelReady: (model) {
        model.retrieveCache();
      },
      builder: (context, model, child) => _resultStack(context, model, _width),
    );
  }

  Widget _resultStack(BuildContext context, ResultPageViewModel model, double _width) {
    return Stack(
      children: <Widget>[
        _resultsView(context, model),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
            child: FloatingActionButton(
              backgroundColor: R.primaryCol,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return BottomSheetForm(
                      yearSelectionVariable: model.yearSelectionVariable,
                      resultTypeVariable: model.resultTypeVariable,
                      sortVariable: model.sortVariable,
                      valueChangedForYear: model.selectYear,
                      valueChangedForResult: model.selectResultType,
                      valueChangedForSort: model.selectSort,
                    );
                  }
                ).then((value) {
                  if(value != null) {
                    model.setFields(value['year'], value['type'], value['sort']);
                  }
                });
              },
              child: Icon(
                Icons.filter_list,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _resultsView(BuildContext context, ResultPageViewModel model) {
    return NestedScrollView(
      controller: model.scrollController,
      headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: Text(Strings.PLACEMENT_YEAR),
            centerTitle: true,
            pinned: true,
            floating: true,
            forceElevated: boxIsScrolled,
            bottom: _resultsListPage(context, model),
          )
        ];
      },
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ResultsBranchWiseView(
            yearSelector : model.yearSelectionVariable,
            internSwitch: model.resultTypeVariable,
            sortSwitch: model.sortVariable,
          ),
          ResultsCompanyWiseView(
            yearSelector : model.yearSelectionVariable,
            internSwitch: model.resultTypeVariable,
            sortSwitch: model.sortVariable,
          ),
        ],
      ),
    );
  }

  Widget _resultsListPage(BuildContext context, ResultPageViewModel model) {
    return TabBar(
      controller: _tabController,
      tabs: _profileTabs,
      unselectedLabelColor: Colors.white70,
      indicatorPadding: EdgeInsets.only(top: 10),
      indicatorColor: Colors.white,
      indicatorWeight: 6.0,
      onTap: (index) {
      },
    );
  }
}