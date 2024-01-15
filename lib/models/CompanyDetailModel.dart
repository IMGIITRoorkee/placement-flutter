class CompanyDetailModel {
  int id;
  String sector, name, email, website, description;
  CompanyDetailModel(
      {required this.id,
      required this.description,
      required this.email,
      required this.name,
      required this.sector,
      required this.website});

  factory CompanyDetailModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailModel(
        description: json['description'] ?? "",
        email: json['email'] ?? "",
        id: json['id'],
        name: json['name'] ?? "",
        sector: json['sector'] ?? "",
        website: json['website'] ?? "");
  }
}
