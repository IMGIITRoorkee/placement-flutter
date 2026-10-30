import 'package:jiffy/jiffy.dart';

import '../locator.dart';
import '../models/DetailCompanyProfileModel.dart';
import '../services/generic/applyService.dart';
import 'BaseViewModel.dart';

class CompanyDetailViewModel extends BaseViewModel {
  DetailCompanyProfileModel? _companyProfile;
  final ApplyService _applyService = locator<ApplyService>();
  late int _profileId;
  DetailCompanyProfileModel? get companyProfile => _companyProfile;

  String formatIt(String? it) {
    if (it == null || it == "") return "-";
    return it;
  }

  bool checkOverallPackage() {
    return (checkPackage("ug") || checkPackage("pg") || checkPackage("phd"));
  }

  bool checkPackage(String st) {
    if (st == "ug") {
      return (_companyProfile?.packageBaseUg != null) ||
          (_companyProfile?.packageCtcUg != null);
    } else if (st == "pg") {
      return (_companyProfile?.packageBasePg != null) ||
          (_companyProfile?.packageCtcPg != null);
    } else if (st == "phd") {
      return (_companyProfile?.packageBasePhd != null) ||
          (_companyProfile?.packageCtcPhd != null);
    } else {
      return true;
    }
  }

  String formatInt(int? it) {
    if (it == null) return "-";
    return it.toString();
  }

  String formatDate(String? it) {
    if (it == null || it == "") return "-";
    final jiffy = Jiffy.parse(it).toLocal();
    return "${jiffy.yMMMd}, ${jiffy.Hm}";
  }

  Future<void> refreshDetails() async {
    await fetchCompanyDetails(_profileId);
  }

  String getTime(String time) {
    List<String> _list = time.split(":");
    return "${_list[0]}:${_list[1]}";
  }

  Future<void> fetchCompanyDetails(int profileId) async {
    _profileId = profileId;
    setLoading();
    _companyProfile = await _applyService.fetchCompanyDetails(profileId);
    setIdle();
  }
}