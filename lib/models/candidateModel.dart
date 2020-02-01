class CandidateModel {
  final int candidateId;
  final String candidateName;
  final int departmentId;
  final String departmentCode;
  final int degreeId;
  final String degreeName;
  final String departmentName;
  final int currentYear;
  final String internshipStatus;

  CandidateModel({
    this.candidateId,
    this.candidateName,
    this.departmentId,
    this.departmentCode,
    this.degreeId,
    this.degreeName,
    this.departmentName,
    this.currentYear,
    this.internshipStatus
  });

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
      internshipStatus: json['status']
    );
  }
}