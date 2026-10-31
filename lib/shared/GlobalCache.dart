import '../models/branchConciseModel.dart';
import '../models/candidateModel.dart';
import '../models/companyConciseModel.dart';
import '../models/profilesModel.dart';

class GlobalCache {

  /**
   * Cache for Result Search filter,
   * "year" - the year index, 0 implies current year, 1 the year before and so on...
   * "type" - 0 means internship, 1 means placement
   */
  Map<String, int>? filterFields;

  CandidateModel? candidateData;

  List<CompanyConciseModel>? companyWiseResults;

  List<BranchConciseModel>? branchWiseResults;

  List<ProfilesModel>? profilesForMe;

  List<ProfilesModel>? profilesOpenForAll;

  void clear() {
    filterFields = null;
    candidateData = null;
    companyWiseResults = null;
    branchWiseResults = null;
    profilesForMe = null;
    profilesOpenForAll = null;
  }
}
