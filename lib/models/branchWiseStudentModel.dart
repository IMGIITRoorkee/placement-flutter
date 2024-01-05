class BranchWiseStudentModel {
  final int studentEnrolmentNumber;
  final String studentName;
  final String companyName;

  BranchWiseStudentModel(
      {required this.studentEnrolmentNumber,
      required this.studentName,
      required this.companyName});

  factory BranchWiseStudentModel.fromJson(Map<String, dynamic> _json) {
    return BranchWiseStudentModel(
        studentEnrolmentNumber: _json['studentEnrolmentNumber'] ?? 0,
        studentName: _json['studentName'] ?? '',
        companyName: _json['companyName'] ?? '');
  }
}
