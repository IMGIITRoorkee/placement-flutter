import 'package:placement/models/BranchRequirementModel.dart';

class CandidateModel {
  int candidateId;
  String candidateName;
  int departmentId;
  String departmentCode;
  int degreeId;
  String degreeName;
  String displayPicture;
  String season;
  int creditsPoolA;
  int creditsPoolB;
  String departmentName;
  int currentYear;
  String internshipStatus;
  BranchRequirementModel branch;

  CandidateModel(
      {required this.candidateId,
      required this.candidateName,
      required this.departmentId,
      required this.departmentCode,
      required this.degreeId,
      required this.degreeName,
      required this.departmentName,
      required this.currentYear,
      required this.internshipStatus,
      required this.branch,
      required this.season,
      required this.creditsPoolA,
      required this.creditsPoolB,
      required this.displayPicture});

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
        candidateId: json['id'],
        candidateName: json['student']['person']['fullName'],
        departmentId: json['student']['branch']['department']['id'],
        departmentCode: json['student']['branch']['department']['code'],
        degreeId: json['student']['branch']['degree']['id'],
        degreeName: json['student']['branch']['degree']['name'],
        departmentName: json['student']['branch']['department']['name'],
        currentYear: json['student']['currentYear'],
        internshipStatus: json['status'],
        season: json['season'],
        creditsPoolA: json['creditsPoolA'],
        creditsPoolB: json['creditsPoolB'],
        branch: BranchRequirementModel.fromJson(json['student']['branch']),
        displayPicture: '');
  }
}
