
import 'package:placement/locator.dart';
import 'package:placement/models/branchConciseModel.dart';
import 'package:placement/services/generic/resultService.dart';
import 'package:placement/shared/GlobalCache.dart';
import 'package:placement/viewmodels/BaseViewModel.dart';

class ResultsBranchWiseViewModel extends BaseViewModel {

  ResultService _resultService = locator<ResultService>();
  GlobalCache _cache = locator<GlobalCache>();
  List<BranchConciseModel> _branchResults = [];
  int _yearIndex, _internSwitch, _sortSwitch;
  bool _isDisposed = false;

  List<BranchConciseModel> get branchResults => _branchResults;
  int get yearIndex => _yearIndex;
  int get internSwitch => _internSwitch;
  int get sortSwitch => _sortSwitch;

  @override
  void dispose() { 
    _isDisposed = true;
    super.dispose();
  }

  void setResultFilter(int yrIndex, int internSwitcher, int sortSwitch) {
    _yearIndex = yrIndex;
    _internSwitch = internSwitcher;
    _sortSwitch = sortSwitch;
    _populateResults();
  }

  Future<void> refreshResults() async {
    _cache.branchWiseResults = null;
    await _populateResults();
  }

  void notif() {
    if(!_isDisposed) notifyListeners();
  }

  Future<void> _populateResults() async {
    _branchResults = await _resultService.branchWiseResults(_yearIndex, _internSwitch);
    if(_sortSwitch == 1) {
      _branchResults.sort(
        (a,b) => a.studentBranchName.compareTo(b.studentBranchName)
      );
    }
    notif();
  }
}