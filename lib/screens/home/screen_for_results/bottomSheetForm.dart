import 'package:flutter/material.dart';
import 'package:placement/resources/modelResources.dart';

class BottomSheetForm extends StatefulWidget {
  BottomSheetForm(
    {
      Key key,
      this.yearSelectionVariable,
      this.resultTypeVariable,
      this.valueChangedForYear,
      this.valueChangedForResult
    }
  ) : super(key: key);
  final int yearSelectionVariable;
  final int resultTypeVariable;
  final ValueChanged valueChangedForYear;
  final ValueChanged valueChangedForResult;

  @override
  _BottomSheetFormState createState() => _BottomSheetFormState();
}

class _BottomSheetFormState extends State<BottomSheetForm> {

  int yearSelectionVariable;
  int resultTypeVariable;

  @override
  void initState() {
    yearSelectionVariable = widget.yearSelectionVariable;
    resultTypeVariable = widget.resultTypeVariable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Card(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Text("Select Year"),
              SizedBox(height: 10,),
              Column(
                children: ModelResources.YEAR_OPTIONS.map( (year) {
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
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10,),
              Text("Select Results type"),
              SizedBox(height: 10,),
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
        )
      ],
    );
  }

  _setYear(val) {
    setState(() {
      yearSelectionVariable = val;
      widget.valueChangedForYear(val);
    });
  }

  _setResultType(val) {
    setState(() {
      resultTypeVariable = val;
      widget.valueChangedForResult(val);
    });
  }
}