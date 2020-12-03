import 'package:placement/models/resumeModel.dart';

class ApplicationModel {
  int id;
  String status,
    profileName,
    profileStatus,
    statusDisplayName;
  ResumeModel resume;

  ApplicationModel({
    this.id,
    this.profileName,
    this.resume,
    this.status,
    this.statusDisplayName,
    this.profileStatus
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    ResumeModel _resume = ResumeModel.fromJson(json['resume']);
    return ApplicationModel(
      id: json['id'] ?? -1,
      profileName: json['profileName'] ?? '',
      resume: _resume,
      status: json['status'] ?? '',
      statusDisplayName: json['statusDisplayName'] ?? '',
      profileStatus: json['profileStatus'] ?? ''
    );
  }
}