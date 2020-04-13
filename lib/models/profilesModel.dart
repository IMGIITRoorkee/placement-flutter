class ProfilesModel {
  final int profileId;
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

  ProfilesModel({
    this.profileId,
    this.companyId,
    this.companyName,
    this.companySector,
    this.companyEmail,
    this.companyDescription,
    this.website,
    this.applicationDeadline,
    this.status,
    this.requiresCoverLetter,
    this.application
  });

  factory ProfilesModel.fromJson(Map<String,dynamic> json) {
    return ProfilesModel(
      profileId: json['id'],
      companyId: json['company']['id'],
      companyName: json['company']['name'],
      companySector: json['company']['sector'],
      companyEmail: json['company']['email'],
      companyDescription: json['company']['description'],
      applicationDeadline: json['applicationDeadline'],
      status: json['profileStatus'] ?? '',
      requiresCoverLetter: json['requiresCoverLetter'] ?? '',
      application: json['application'] ?? '',
    );
  }
}