class BranchConciseModel {
  final String studentDegree;
  final String studentBranchName;
  final String selected;
  final String studentDetails;
  final String companyDetails;

  BranchConciseModel(
      {required this.studentDegree,
      required this.studentBranchName,
      required this.selected,
      required this.studentDetails,
      required this.companyDetails});

  factory BranchConciseModel.fromJson(Map<String, dynamic> _json) {
    return BranchConciseModel(
      studentDegree: _json['studentDegree'] ?? '',
      studentBranchName: _json['studentBranchName'] ?? '',
      selected: _json['selected'] ?? '0',
      studentDetails: _json['studentDetails'] ?? '',
      companyDetails: _json['companyDetails'] ?? '',
    );
  }
}
