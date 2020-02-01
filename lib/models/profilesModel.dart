class ProfilesModel {
  final int profileId;
  final int companyId;
  final String companyName;
  final String website;
  final String applicationDeadline;
  final String status;

  ProfilesModel({
    this.profileId,
    this.companyId,
    this.companyName,
    this.website,
    this.applicationDeadline,
    this.status,
  });

  factory ProfilesModel.fromJson(Map<String,dynamic> json) {
    return ProfilesModel(
      profileId: json['id'],
      companyId: json['company']['id'],
      companyName: json['company']['name'],
      applicationDeadline: json['applicationDeadline'],
      status: json['profileStatus'] ?? '',
    );
  }
}