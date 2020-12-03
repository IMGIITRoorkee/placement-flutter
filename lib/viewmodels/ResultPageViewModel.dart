
import 'package:flutter/material.dart';
import 'package:placement/locator.dart';
import 'package:placement/shared/GlobalCache.dart';
import 'package:placement/viewmodels/BaseViewModel.dart';

class ResultPageViewModel extends BaseViewModel {
  
  final ScrollController _scrollController = ScrollController();
  GlobalCache _cache = locator<GlobalCache>();
  int _yearSelectionVariable;
  int _resultTypeVariable; 
  int _sortVariable;
  bool _isDisposed = false;

  int get yearSelectionVariable => _yearSelectionVariable;
  int get resultTypeVariable => _resultTypeVariable;
  int get sortVariable => _sortVariable;
  ScrollController get scrollController => _scrollController;

  @override
  void dispose() { 
    _scrollController.dispose();
    super.dispose();
  }

  void retrieveCache() {
    if(_cache.filterFields == null) {
      Map<String, dynamic> _cacheMap = {
        "year" : 0,
        "type" : 0,
        "sort" : 0
      };
      _cache.filterFields = _cacheMap;
      _yearSelectionVariable = 0;
      _resultTypeVariable = 0;
      _sortVariable = 0;
    } else {
      _yearSelectionVariable = _cache.filterFields['year'];
      _resultTypeVariable = _cache.filterFields['type'];
      _sortVariable = _cache.filterFields['sort'];
    }
  }

  void _cacheFields() {
    _cache.filterFields['year'] = _yearSelectionVariable;
    _cache.filterFields['type'] = _resultTypeVariable;
    _cache.filterFields['sort'] = _sortVariable;
  }

  void _notif() {
    if(!_isDisposed) notifyListeners();
  }

  void setFields(int year, int type, int sort) {
    _yearSelectionVariable = year;
    _resultTypeVariable = type;
    _sortVariable = sort;
    print("SETTING THE FIELDS $_yearSelectionVariable - $_resultTypeVariable - $_sortVariable");
    _notif();
    _deleteCachedResults();
    _cacheFields();
  }

  void _deleteCachedResults() {
    _cache.companyWiseResults = null;
    _cache.branchWiseResults = null;
  }

  void selectYear(int year) {
    _yearSelectionVariable = year;
    _notif();
    _cacheFields();
  }

  void selectSort(int sort) {
    _sortVariable = sort;
    _notif();
    _cacheFields();
  }

  void selectResultType(int type) {
    _resultTypeVariable = type;
    _notif();
    _cacheFields();
  }
}