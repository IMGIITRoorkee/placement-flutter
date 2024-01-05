class SelectedStudentModel {
  final String studentName;
  final String studentBranchName;
  final int studentEnrolmentNumber;

  SelectedStudentModel(
      {required this.studentName,
      required this.studentBranchName,
      required this.studentEnrolmentNumber});

  factory SelectedStudentModel.fromJson(Map<String, dynamic> _json) {
    return SelectedStudentModel(
      studentBranchName: _json[''],
      studentEnrolmentNumber: _json[''],
      studentName: _json[''],
    );
  }
}
