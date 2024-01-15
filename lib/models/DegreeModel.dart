class DegreeModel {
  int id;
  String code, name, graduation;

  DegreeModel(
      {required this.code,
      required this.graduation,
      required this.id,
      required this.name});

  factory DegreeModel.fromJson(Map<String, dynamic> json) {
    return DegreeModel(
        code: json['code'] ?? "",
        graduation: json['graduation'] ?? "",
        id: json['id'],
        name: json['name'] ?? "");
  }
}
