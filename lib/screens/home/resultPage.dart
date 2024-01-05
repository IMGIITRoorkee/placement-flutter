import 'package:flutter/material.dart';
import 'package:placement/resources/strings.dart';
import 'package:placement/screens/home/screen_for_results/bottomSheetForm.dart';
import 'package:placement/screens/home/screen_for_results/resultsBranchWise.dart';
import 'package:placement/screens/home/screen_for_results/resultsCompanyWise.dart';

class ResultPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const ResultPage({required Key key, required this.args}) : super(key: key);
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  late int _yearSelectionVariable;
  late int _resultTypeVariable;

  @override
  void initState() {
    super.initState();
    _yearSelectionVariable = 0;
    _resultTypeVariable = 0;
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
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
    final double _height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        _resultsView(context),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: BottomSheetForm(
                        sortVariable: 0,
                        yearSelectionVariable: _yearSelectionVariable,
                        resultTypeVariable: _resultTypeVariable,
                        valueChangedForYear: (yearSelectionVariable) {
                          _yearSelectionVariable = yearSelectionVariable;
                        },
                        valueChangedForResult: (resultTypeVariable) {
                          _resultTypeVariable = resultTypeVariable;
                        },
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.filter_b_and_w),
            ),
          ),
        )
      ],
    );
  }

  Widget _resultsView(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: Text(Strings.PLACEMENT_YEAR),
            centerTitle: true,
            pinned: true,
            floating: true,
            forceElevated: boxIsScrolled,
            bottom: _resultsListPage(context),
          )
        ];
      },
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ResultsBranchWise(),
          ResultsCompanyWise(),
        ],
      ),
    );
  }

  PreferredSizeWidget _resultsListPage(BuildContext context) {
    return TabBar(
      controller: _tabController,
      tabs: _profileTabs,
      unselectedLabelColor: Colors.white70,
      indicatorPadding: EdgeInsets.only(top: 10),
      indicatorColor: Colors.white,
      indicatorWeight: 6.0,
      onTap: (index) {},
    );
  }
}
