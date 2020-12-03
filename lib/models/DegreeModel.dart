class DegreeModel {
  int id;
  String code,
    name,
    graduation;
  
  DegreeModel({
    this.code,
    this.graduation,
    this.id,
    this.name
  });

  factory DegreeModel.fromJson(Map<String, dynamic> json) {
    return DegreeModel(
      code: json['code'] ?? "",
      graduation: json['graduation'] ?? "",
      id: json['id'],
      name: json['name'] ?? ""
    );
  }
}