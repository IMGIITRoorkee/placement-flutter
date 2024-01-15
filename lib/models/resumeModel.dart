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

  ResumeModel(
      {required this.id,
      required this.candidate,
      required this.title,
      required this.isDefault,
      this.interests,
      this.achievements,
      required this.computerLanguages,
      required this.softwarePackages,
      required this.additionalCourses,
      required this.minorCourses,
      required this.languages,
      required this.isVerified,
      required this.resumeUrl});

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
        isVerified: _data['isVerified'],
        resumeUrl: '');
  }
}
