class ResumeModel {
  int id;
  String candidate;
  String title;
  bool isDefault;
  bool isVerified;
  dynamic interests;
  dynamic achievements;
  String computerLanguages;
  String softwarePackages;
  String additionalCourses;
  String minorCourses;
  String languages;
  String resumeUrl;

  ResumeModel({
    this.id,
    this.candidate,
    this.title,
    this.isDefault,
    this.interests,
    this.achievements,
    this.computerLanguages,
    this.softwarePackages,
    this.additionalCourses,
    this.minorCourses,
    this.languages,
    this.isVerified,
    this.resumeUrl
  });

  factory ResumeModel.fromJson(Map<String, dynamic> _data) {
    return ResumeModel(
      id: _data['id'],
      candidate: _data['candidate'],
      title: _data['title'],
      isDefault: _data['isDefault'],
      interests: _data['interests'],
      achievements: _data['achievements'],
      computerLanguages: _data['computerLanguages'],
      softwarePackages: _data['softwarePackages'],
      additionalCourses: _data['additionalCourses'],
      minorCourses: _data['minorCourses'],
      languages: _data['languages'],
      isVerified: _data['isVerified']
    );
  }
}