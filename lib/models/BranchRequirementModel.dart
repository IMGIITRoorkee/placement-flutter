import 'package:placement/models/DegreeModel.dart';
import 'package:placement/models/DepartmentModel.dart';

class BranchRequirementModel {
  
  int id;
  String code,
    name;
  DegreeModel degree;
  DepartmentModel department;

  BranchRequirementModel({
    this.code,
    this.degree,
    this.department,
    this.id,
    this.name
   });

  factory BranchRequirementModel.fromJson(Map<String, dynamic> json) {
    return BranchRequirementModel(
      code: json['code'] ?? "",
      degree: DegreeModel.fromJson(json['degree']),
      department: DepartmentModel.fromJson(json['department']),
      id: json['id'],
      name: json['name'] ?? "",
    );
  }
}