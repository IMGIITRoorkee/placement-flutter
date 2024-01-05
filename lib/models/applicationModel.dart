import 'package:placement/models/resumeModel.dart';

class ApplicationModel {
  int id;
  String status, profileName, profileStatus, statusDisplayName;
  ResumeModel resume;

  ApplicationModel(
      {required this.id,
      required this.profileName,
      required this.resume,
      required this.status,
      required this.statusDisplayName,
      required this.profileStatus});

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    ResumeModel _resume = ResumeModel.fromJson(json['resume']);
    return ApplicationModel(
        id: json['id'] ?? -1,
        profileName: json['profileName'] ?? '',
        resume: _resume,
        status: json['status'] ?? '',
        statusDisplayName: json['statusDisplayName'] ?? '',
        profileStatus: json['profileStatus'] ?? '');
  }
}
