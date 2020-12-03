
import 'package:placement/locator.dart';
import 'package:placement/models/companyConciseModel.dart';
import 'package:placement/services/generic/resultService.dart';
import 'package:placement/shared/GlobalCache.dart';
import 'package:placement/viewmodels/BaseViewModel.dart';

class ResultsCompanyWiseViewModel extends BaseViewModel {

  ResultService _resultService = locator<ResultService>();
  GlobalCache _cache = locator<GlobalCache>();
  List<CompanyConciseModel> _companyResults = [];
  int _yearIndex, _internSwitch, _sortSwitch;
  bool _isDisposed = false;

  List<CompanyConciseModel> get companyResults => _companyResults;
  int get yearIndex => _yearIndex;
  int get internSwitch => _internSwitch;
  int get sortSwitch => _sortSwitch;
  @override
  void dispose() { 
    _isDisposed = true;
    super.dispose();
  }

  void setResultFilter(int yrIndex, int internSwitcher, int sortIndex) {
    _yearIndex = yrIndex;
    _internSwitch = internSwitcher;
    _sortSwitch = sortIndex;
    _populateResults();
  }

  Future<void> refreshResults() async {
    _cache.companyWiseResults = null;
    await _populateResults();
  }

  void notif() {
    if(!_isDisposed) notifyListeners();
  }

  Future<void> _populateResults() async {
    _companyResults = await _resultService.companyWiseResults(_yearIndex, _internSwitch);
    if(_sortSwitch == 1) _companyResults.sort(
      (a,b) => a.companyName.compareTo(b.companyName)
    );
    notif();
  }
}