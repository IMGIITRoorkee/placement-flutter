import 'package:jiffy/jiffy.dart';
import 'package:placement/locator.dart';
import 'package:placement/models/DetailCompanyProfileModel.dart';
import 'package:placement/services/generic/applyService.dart';
import 'package:placement/viewmodels/BaseViewModel.dart';

class CompanyDetailViewModel extends BaseViewModel {
  DetailCompanyProfileModel? _companyProfile;
  ApplyService _applyService = locator<ApplyService>();
  bool _isDisposed = false;
  bool _isLoading = false;
  late int _profileId;

  bool get isLoading => _isLoading;
  DetailCompanyProfileModel get companyProfile => _companyProfile!;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void notif() {
    if (!_isDisposed) notifyListeners();
  }

  String formatIt(String it) {
    if (it == null || it == "") return "-";
    return it;
  }

  bool checkOverallPackage() {
    return (checkPackage("ug") || checkPackage("pg") || checkPackage("phd"));
  }

  bool checkPackage(String st) {
    if (st == "ug")
      return (_companyProfile!.packageBaseUg != null) ||
          (_companyProfile!.packageCtcUg != null);
    else if (st == "pg")
      return (_companyProfile!.packageBasePg != null) ||
          (_companyProfile!.packageCtcPg != null);
    else if (st == "phd")
      return (_companyProfile!.packageBasePhd != null) ||
          (_companyProfile!.packageCtcPhd != null);
    else
      return true;
  }

  String formatInt(int? it) {
    if (it == null) return "-";
    return it.toString();
  }

  String formatDate(String it) {
    if (it == "") return "-";
    return Jiffy(it).yMMMd + ", " + Jiffy(it).Hm;
  }

  Future<void> refreshDetails() async {
    await fetchCompanyDetails(_profileId);
  }

  String getTime(String time) {
    List<String> _list = time.split(":");
    return _list[0] + ":" + _list[1];
  }

  Future<void> fetchCompanyDetails(int profileId) async {
    print("DETAIL FOR PID $profileId");
    _profileId = profileId;
    _isLoading = true;
    notif();
    _companyProfile = await _applyService.fetchCompanyDetails(profileId);
    _isLoading = false;
    notif();
  }
}
