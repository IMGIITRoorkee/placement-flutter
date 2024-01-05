import 'package:placement/models/BranchRequirementModel.dart';
import 'package:placement/models/CompanyDetailModel.dart';
import 'package:placement/models/RoundSetModel.dart';
import 'package:placement/models/applicationModel.dart';

class DetailCompanyProfileModel {
  int id, applicationCost, talkAbsenceCost;
  int? packageCtcUg,
      packageCtcPg,
      packageCtcPhd,
      packageBaseUg,
      packageBasePg,
      packageBasePhd;
  CompanyDetailModel company;
  dynamic application;
  String name,
      profileStatus,
      category,
      cgpaRequirement,
      description,
      packageDescription,
      post,
      location,
      targetCreditPool,
      applicationDeadline,
      talkDate,
      talkStatus;
  bool requiresCoverLetter, talkPresenceRequired;
  List<BranchRequirementModel> branchRequirement;
  final List<RoundSetModel> roundSet;

  DetailCompanyProfileModel(
      {this.application,
      required this.applicationDeadline,
      required this.category,
      required this.cgpaRequirement,
      required this.company,
      required this.description,
      required this.id,
      required this.location,
      required this.name,
      required this.post,
      required this.profileStatus,
      required this.requiresCoverLetter,
      required this.targetCreditPool,
      required this.applicationCost,
      required this.packageCtcPg,
      required this.packageCtcPhd,
      required this.packageCtcUg,
      required this.talkAbsenceCost,
      required this.talkDate,
      required this.talkPresenceRequired,
      required this.branchRequirement,
      required this.packageDescription,
      required this.talkStatus,
      required this.packageBasePg,
      required this.packageBasePhd,
      required this.packageBaseUg,
      required this.roundSet});

  factory DetailCompanyProfileModel.fromJson(Map<String, dynamic> json) {
    CompanyDetailModel company = CompanyDetailModel.fromJson(json['company']);
    List<BranchRequirementModel> branchList = [];
    for (var item in json['branchRequirement']) {
      branchList.add(BranchRequirementModel.fromJson(item));
    }
    List<RoundSetModel> _roundSet = [];
    print("RounrSet!!! = " + json['roundSet'].toString());
    for (var item in json['roundSet']) {
      _roundSet.add(RoundSetModel.fromJson(item));
    }
    var _application;
    if (json['application'] is String) {
      _application = json['application'];
    } else {
      _application = ApplicationModel.fromJson(json['application']);
    }
    return DetailCompanyProfileModel(
        application: _application,
        applicationCost: json['applicationCost'],
        applicationDeadline: json['applicationDeadline'] ?? "",
        category: json['category'] ?? "",
        cgpaRequirement: json['cgpaRequirement'],
        company: company,
        description: json['description'] ?? "",
        id: json['id'],
        location: json['location'] ?? "",
        name: json['name'] ?? "",
        post: json['post'] ?? "",
        profileStatus: json['profileStatus'] ?? "",
        requiresCoverLetter: json['requiresCoverLetter'],
        targetCreditPool: json['targetCreditPool'] ?? "",
        packageCtcPg: json['packageCtcPg'],
        packageCtcPhd: json['packageCtcPhd'],
        packageCtcUg: json['packageCtcUg'],
        talkAbsenceCost: json['talkAbsenceCost'],
        talkDate: json['talkDate'] ?? "",
        talkPresenceRequired: json['talkPresenceRequired'] ?? "",
        branchRequirement: branchList,
        packageDescription: json['packageDescription'] ?? "",
        talkStatus: json['talkStatus'] ?? "",
        packageBasePg: json['packageBasePg'],
        packageBasePhd: json['packageBasePhd'],
        packageBaseUg: json['packageBaseUg'],
        roundSet: _roundSet);
  }
}
