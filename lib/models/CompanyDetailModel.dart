class CompanyDetailModel {
  int id;
  String sector,
    name,
    email,
    website,
    description;
  CompanyDetailModel({
    this.id,
    this.description,
    this.email,
    this.name,
    this.sector,
    this.website
  });

  factory CompanyDetailModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailModel(
      description: json['description'] ?? "",
      email: json['email'] ?? "",
      id: json['id'],
      name: json['name'] ?? "",
      sector: json['sector'] ?? "",
      website: json['website'] ?? ""
    );
  }
}