class DepartmentModel {
  int id;
  String code, name;

  DepartmentModel({required this.code, required this.id, required this.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
        code: json['code'] ?? "", id: json['id'], name: json['name'] ?? "");
  }
}
