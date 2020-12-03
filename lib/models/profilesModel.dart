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

  ProfilesModel({
    this.profileId,
    this.name,
    this.companyId,
    this.companyName,
    this.companySector,
    this.companyEmail,
    this.companyDescription,
    this.website,
    this.applicationDeadline,
    this.status,
    this.requiresCoverLetter,
    this.application,
    this.roundSet
  });

  factory ProfilesModel.fromJson(Map<String,dynamic> json) {
    var _application;
    List<RoundSetModel> _roundSet = [];
    if(json['application'] is String) {
      _application = json['application'];
    } else {
      _application = ApplicationModel.fromJson(json['application']);
    }
    return ProfilesModel(
      profileId: json['id'],
      name: json['name'],
      companyId: json['company']['id'],
      companyName: json['company']['name'],
      companySector: json['company']['sector'],
      companyEmail: json['company']['email'],
      companyDescription: json['company']['description'],
      applicationDeadline: json['applicationDeadline'],
      status: json['profileStatus'] ?? '',
      requiresCoverLetter: json['requiresCoverLetter'] ?? '',
      application: _application,
      roundSet: _roundSet
    );
  }
}