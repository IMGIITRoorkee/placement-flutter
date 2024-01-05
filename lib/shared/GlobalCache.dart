import 'package:placement/models/branchConciseModel.dart';
import 'package:placement/models/candidateModel.dart';
import 'package:placement/models/companyConciseModel.dart';
import 'package:placement/models/profilesModel.dart';

class GlobalCache {
  /**
   * Cache for Result Search filter,
   * "year" - the year index, 0 implies current year, 1 the year before and so on...
   * "type" - 0 means internship, 1 means placement
   */
  Map<String, dynamic>? filterFields;

  CandidateModel? candidateData;

  List<CompanyConciseModel>? companyWiseResults;

  List<BranchConciseModel>? branchWiseResults;

  List<ProfilesModel>? profilesForMe;

  List<ProfilesModel>? profilesOpenForAll;
}
