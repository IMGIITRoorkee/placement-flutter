import 'package:placement/models/BranchRequirementModel.dart';
import 'package:placement/models/CompanyDetailModel.dart';
import 'package:placement/models/RoundSetModel.dart';
import 'package:placement/models/applicationModel.dart';

class DetailCompanyProfileModel {
  int id,
    applicationCost,
    packageCtcUg,
    packageCtcPg,
    packageCtcPhd,
    packageBaseUg,
    packageBasePg,
    packageBasePhd,
    talkAbsenceCost;
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
  bool requiresCoverLetter,
    talkPresenceRequired;
  List<BranchRequirementModel> branchRequirement;
  final List<RoundSetModel> roundSet;

  DetailCompanyProfileModel({
    this.application, this.applicationDeadline, this.category,
    this.cgpaRequirement, this.company, this.description,
    this.id, this.location, this.name,
    this.post, this.profileStatus, this.requiresCoverLetter,
    this.targetCreditPool, this.applicationCost, this.packageCtcPg,
    this.packageCtcPhd, this.packageCtcUg, this.talkAbsenceCost,
    this.talkDate, this.talkPresenceRequired, this.branchRequirement,
    this.packageDescription, this.talkStatus, this.packageBasePg,
    this.packageBasePhd, this.packageBaseUg, this.roundSet
  });

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
    if(json['application'] is String) {
      _application = json['application'];
    } else {
      _application = ApplicationModel.fromJson(json['application']);
    }
    return DetailCompanyProfileModel(
      application: _application,
      applicationCost : json['applicationCost'],
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
      roundSet: _roundSet
    );
  }
}