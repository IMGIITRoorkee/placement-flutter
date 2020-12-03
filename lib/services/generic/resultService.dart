
import 'package:placement/locator.dart';
import 'package:placement/models/branchConciseModel.dart';
import 'package:placement/models/branchWiseStudentModel.dart';
import 'package:placement/models/companyConciseModel.dart';
import 'package:placement/models/companyWiseStudentModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/resources/fetchedResources.dart';
import 'package:placement/services/generic/requestService.dart';
import 'package:placement/shared/GlobalCache.dart';

class ResultService {

  final RequestService _requestService = locator<RequestService>();
  final GlobalCache _cache = locator<GlobalCache>();
  FetchedResources _fetchedResources = FetchedResources();

  Future<List<CompanyConciseModel>> companyWiseResults(int yearIndex, int internSwitch) async {
    List<CompanyConciseModel> _companyResults = [];
    if(_cache.companyWiseResults == null) {
      var _data = await _requestService.makeGetRequest(
        EndPoints.RESULTS_HOST + EndPoints.year(yearIndex) + EndPoints.RESULTS_COMPANY[internSwitch] + EndPoints.WITH_INDEX
      );
      if(_data == -2) return null;
      if(_data != -1 && _data != -2) {
        for (var r in _data) {
          _companyResults.add(CompanyConciseModel.fromJson(r));
        }
        if(_companyResults.length > 0) {
          _cache.companyWiseResults = _companyResults;
        }
      }
      return _companyResults;
    }
    return _cache.companyWiseResults;
  }

  Future<List<BranchConciseModel>> branchWiseResults(int yearIndex, int internSwitch) async {
    List<BranchConciseModel> _branchResults = [];
    if(_cache.branchWiseResults == null) {
      var _data = await _requestService.makeGetRequest(
        EndPoints.RESULTS_HOST + EndPoints.year(yearIndex) + EndPoints.RESULTS_BRANCH[internSwitch] + EndPoints.WITH_INDEX
      );
      if(_data == -2) return null;
      if(_data != -1 && _data != -2) {
        for (var r in _data) {
          _branchResults.add(BranchConciseModel.fromJson(r));
        }
        if(_branchResults.length > 0) _cache.branchWiseResults = _branchResults;
      }
      return _branchResults;
    } else {
      return _cache.branchWiseResults;
    }
  }

  //TODO: Convert Detail Result pages to MVVM
  Future<List<CompantWiseStudentModel>> companyWiseDetailResult(String args) async {
    List<CompantWiseStudentModel> _results = [];
    var _data = await _requestService.makeGetRequest(
      EndPoints.RESULTS_HOST + args
    );
    for(var r in _data) {
      _results.add(CompantWiseStudentModel.fromJson(r));
    }
    return _results;
  }

  Future<List<BranchWiseStudentModel>> branchWiseDetailResult(String args) async {
    List<BranchWiseStudentModel> _results = [];
    var _data = await _requestService.makeGetRequest(
      EndPoints.RESULTS_HOST + args
    );
    for(var r in _data) {
      _results.add(BranchWiseStudentModel.fromJson(r));
    }
    return _results;
  }
}