class BranchWiseStudentModel {
  final int studentEnrolmentNumber;
  final String studentName;
  final String companyName;

  BranchWiseStudentModel({
    this.studentEnrolmentNumber,
    this.studentName,
    this.companyName
  });

  factory BranchWiseStudentModel.fromJson(Map<String, dynamic> _json) {
    return BranchWiseStudentModel(
      studentEnrolmentNumber: _json['studentEnrolmentNumber'] ?? 0,
      studentName: _json['studentName'] ?? '',
      companyName: _json['companyName'] ?? ''
    );
  }
}