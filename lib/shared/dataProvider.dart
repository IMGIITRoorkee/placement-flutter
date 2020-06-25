import 'package:flutter/cupertino.dart';

class DataProvider with ChangeNotifier {

  int _yearSelector;
  bool _placementResultSelector;

  static final _data = DataProvider.internal();

  factory DataProvider() => _data;

  DataProvider.internal() {
    initState();
  }

  initState() {
    _yearSelector = 0;
    _placementResultSelector = true;
  }


  int get yearSelector => _yearSelector;
  void yearSetter(int year) {
    _yearSelector = year;
    notifyListeners();
  }

}