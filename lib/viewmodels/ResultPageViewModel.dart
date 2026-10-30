import 'package:flutter/material.dart';

import '../locator.dart';
import '../shared/GlobalCache.dart';
import 'BaseViewModel.dart';

class ResultPageViewModel extends BaseViewModel {
  
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  GlobalCache _cache = locator<GlobalCache>();

  late int _yearSelectionVariable, _resultTypeVariable, _sortVariable;
  int get yearSelectionVariable => _yearSelectionVariable;
  int get resultTypeVariable => _resultTypeVariable;
  int get sortVariable => _sortVariable;

  @override
  void dispose() { 
    _scrollController.dispose();
    super.dispose();
  }

  void retrieveCache() {
    if(_cache.filterFields == null) {
      Map<String, int> _cacheMap = {
        "year" : 0,
        "type" : 0,
        "sort" : 0
      };
      _cache.filterFields = _cacheMap;
    }
    _yearSelectionVariable = _cache.filterFields!['year'] ?? 0;
    _resultTypeVariable = _cache.filterFields!['type'] ?? 0;
    _sortVariable = _cache.filterFields!['sort'] ?? 0;
  }

  void _cacheFields() {
    _cache.filterFields
    ?..['year'] = _yearSelectionVariable
    ..['type'] = _resultTypeVariable
    ..['sort'] = _sortVariable;
  }

  void setFields(int? year, int? type, int? sort) {
    _yearSelectionVariable = year ?? 0;
    _resultTypeVariable = type ?? 0;
    _sortVariable = sort ?? 0;
    reload();
    _deleteCachedResults();
    _cacheFields();
  }

  void _deleteCachedResults() {
    _cache.companyWiseResults = null;
    _cache.branchWiseResults = null;
  }
}
