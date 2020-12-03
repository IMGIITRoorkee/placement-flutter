class DepartmentModel {
  int id;
  String code,
    name;

  DepartmentModel({
    this.code,
    this.id,
    this.name
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      code: json['code'] ?? "",
      id: json['id'],
      name: json['name'] ?? ""
    );
  }
}