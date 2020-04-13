class ResumeModel {
  final int id;
  final String candidate;
  final String title;
  final bool isDefault;
  final dynamic interests;
  final dynamic achievements;
  final String computerLanguages;
  final String softwarePackages;
  final String additionalCourses;
  final String minorCourses;
  final String languages;

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
    this.languages
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
    );
  }
}