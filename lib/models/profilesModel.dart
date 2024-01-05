import 'package:placement/models/RoundSetModel.dart';
import 'package:placement/models/applicationModel.dart';

class ProfilesModel {
  final int profileId;
  final String name;
  final int companyId;
  final String companyName;
  final String companySector;
  final String companyEmail;
  final String companyDescription;
  final String website;
  final String applicationDeadline;
  final String status;
  final bool requiresCoverLetter;
  final application;
  final List<RoundSetModel> roundSet;

  ProfilesModel(
      {required this.profileId,
      required this.name,
      required this.companyId,
      required this.companyName,
      required this.companySector,
      required this.companyEmail,
      required this.companyDescription,
      required this.website,
      required this.applicationDeadline,
      required this.status,
      required this.requiresCoverLetter,
      this.application,
      required this.roundSet});

  factory ProfilesModel.fromJson(Map<String, dynamic> json) {
    var _application;
    List<RoundSetModel> _roundSet = [];
    if (json['application'] is String) {
      _application = json['application'];
    } else {
      _application = ApplicationModel.fromJson(json['application']);
    }
    return ProfilesModel(
        profileId: json['id'] ?? 0,
        name: json['name'] ?? "",
        companyId: json['company']['id'] ?? 0,
        companyName: json['company']['name'] ?? "",
        companySector: json['company']['sector'] ?? "",
        companyEmail: json['company']['email'] ?? "",
        companyDescription: json['company']['description'] ?? "",
        applicationDeadline: json['applicationDeadline'] ?? "",
        status: json['profileStatus'] ?? '',
        requiresCoverLetter: json['requiresCoverLetter'] ?? '',
        application: _application,
        roundSet: _roundSet,
        website: '');
  }
}
