class CompanyConciseModel {
  final String companyName;
  final String selected;
  final String detail;

  CompanyConciseModel({
    this.companyName,
    this.selected,
    this.detail
  });

  factory CompanyConciseModel.fromJson(Map<String, dynamic> _json) {
    return CompanyConciseModel(
      companyName: _json['companyName'] ?? '',
      selected: _json['selected'] ?? '',
      detail: _json['detail'] ?? '',
    );
  }
}