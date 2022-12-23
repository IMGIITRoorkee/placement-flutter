import 'package:flutter/material.dart';
import 'package:placement/locator.dart';
import 'package:placement/resources/R.dart';
import 'package:placement/resources/modelResources.dart';
import 'package:placement/shared/GlobalCache.dart';

class BottomSheetForm extends StatefulWidget {
  BottomSheetForm(
      {Key key,
      this.yearSelectionVariable,
      this.resultTypeVariable,
      this.sortVariable,
      this.valueChangedForYear,
      this.valueChangedForResult,
      this.valueChangedForSort})
      : super(key: key);
  final int yearSelectionVariable;
  final int resultTypeVariable;
  final int sortVariable;
  final valueChangedForYear;
  final valueChangedForResult;
  final valueChangedForSort;

  @override
  _BottomSheetFormState createState() => _BottomSheetFormState();
}

class _BottomSheetFormState extends State<BottomSheetForm> {
  int yearSelectionVariable;
  int resultTypeVariable;
  int sortVariable;
  GlobalCache _cache = locator<GlobalCache>();

  @override
  void initState() {
    yearSelectionVariable = widget.yearSelectionVariable;
    resultTypeVariable = widget.resultTypeVariable;
    sortVariable = widget.sortVariable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _yearCard(context),
          _typeCard(context),
          _sortCard(context),
          _filterButton(context),
        ],
      ),
    );
  }

  Widget _filterButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: Text(
          'Get Results',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.pop(
            context,
            {
              'year': yearSelectionVariable,
              'type': resultTypeVariable,
              'sort': sortVariable
            },
          );
        },
      ),
    );
  }

  Widget _yearCard(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            "Select Year",
            style: TextStyle(color: R.textColPrimary),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: ModelResources.yearOptions().map((year) {
              return RadioListTile(
                groupValue: yearSelectionVariable,
                value: year.key,
                title: Text(year.value),
                onChanged: (val) {
                  _setYear(val);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _sortCard(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            "Sort By",
            style: TextStyle(color: R.textColPrimary),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: ModelResources.SORT_OPTIONS.map((resultType) {
              return RadioListTile(
                groupValue: sortVariable,
                value: resultType.key,
                title: Text(resultType.value),
                onChanged: (val) {
                  _setSortVar(val);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _typeCard(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            "Select Results type",
            style: TextStyle(color: R.textColPrimary),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: ModelResources.RESULT_OPTIONS.map((resultType) {
              return RadioListTile(
                groupValue: resultTypeVariable,
                value: resultType.key,
                title: Text(resultType.value),
                onChanged: (val) {
                  _setResultType(val);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  _setYear(val) {
    setState(() {
      yearSelectionVariable = val;
    });
  }

  _setResultType(val) {
    setState(() {
      resultTypeVariable = val;
    });
  }

  _setSortVar(val) {
    setState(() {
      sortVariable = val;
    });
  }
}
