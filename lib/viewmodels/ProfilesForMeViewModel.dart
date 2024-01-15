import 'package:jiffy/jiffy.dart';
import 'package:placement/locator.dart';
import 'package:placement/models/profilesModel.dart';
import 'package:placement/resources/modelResources.dart';
import 'package:placement/services/api_models/deleteService.dart';
import 'package:placement/services/generic/applyService.dart';
import 'package:placement/shared/GlobalCache.dart';
import 'package:placement/viewmodels/BaseViewModel.dart';

class ProfilesForMeViewModel extends BaseViewModel {
  ApplyService _applyService = locator<ApplyService>();
  GlobalCache _cache = locator<GlobalCache>();
  DeleteService _deleteService = DeleteService();
  List<ProfilesModel>? _profiles = [];
  bool _isDisposed = false;
  bool _loading = false;
  bool _isNull = false;

  List<ProfilesModel>? get profiles => _profiles;
  bool get isLoading => _loading;
  bool get isNull => _isNull;

  @override
  void dispose() {
    _isDisposed = true;
    print("DISPOSING FOR ME!!");
    super.dispose();
  }

  void notif() {
    if (!_isDisposed) notifyListeners();
  }

  void _destroyProfileCache() {
    _cache.profilesForMe = null;
    _cache.profilesOpenForAll = null;
  }

  String formatDate(String it) {
    if (it == "") return "-";
    return Jiffy(it).yMMMd + " - " + Jiffy(it).Hm;
  }

  String profileStatus(int index) {
    if (_profiles![index].status == "locked")
      return _profiles![index].application.statusDisplayName;
    else if (_profiles![index].status == "open" &&
        _profiles![index].applicationDeadline != null) {
      String date =
          "Apply before " + formatDate(_profiles![index].applicationDeadline);
      return date;
    } else if (_profiles![index].status == "withdrawable")
      return _profiles![index].application.resume.title + " Sent";
    return ModelResources.analyseProfileStatus(_profiles![index].status);
  }

  Future<void> refreshAndWait() async {
    _destroyProfileCache();
    await populateProfiles();
  }

  void refresh() {
    _destroyProfileCache();
    populateProfiles();
  }

  Future<void> deleteApplication(int applicationId) async {
    print("DELETING FOR PID $applicationId");
    await _deleteService.deleteApplicationService(applicationId);
    refresh();
  }

  Future<void> populateProfiles() async {
    _loading = true;
    notif();
    _profiles = await _applyService.fetchProfileForMe();
    if (_profiles == null) _isNull = true;
    _loading = false;
    notif();
  }
}
