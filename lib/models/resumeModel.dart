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
      id: _data[''],
      candidate: _data[''],
      title: _data[''],
      isDefault: _data[''],
      interests: _data[''],
      achievements: _data[''],
      computerLanguages: _data[''],
      softwarePackages: _data[''],
      additionalCourses: _data[''],
      minorCourses: _data[''],
      languages: _data[''],
    );
  }
}