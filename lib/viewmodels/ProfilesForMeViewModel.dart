
import 'package:jiffy/jiffy.dart';

import '../locator.dart';
import '../models/profilesModel.dart';
import '../resources/modelResources.dart';
import '../services/api_models/deleteService.dart';
import '../services/generic/applyService.dart';
import '../shared/GlobalCache.dart';
import 'BaseViewModel.dart';

class ProfilesForMeViewModel extends BaseViewModel {

  ApplyService _applyService = locator<ApplyService>();
  GlobalCache _cache = locator<GlobalCache>();
  DeleteService _deleteService = DeleteService();
  List<ProfilesModel>? _profiles= [];
  List<ProfilesModel>? get profiles => _profiles;

  void _destroyProfileCache() {
    _cache.profilesForMe = null;
    _cache.profilesOpenForAll = null;
  }

  String formatDate(String it) {
    if(it == "") return "-";
    return Jiffy.parse(it).toLocal().yMMMd + " - " + Jiffy.parse(it).toLocal().Hm;
  }

  String profileStatus(int index) {
    final profiles = _profiles;
    if (profiles == null) {
      return "-";
    };
    if(profiles[index].status == "locked") return profiles[index].application.statusDisplayName ?? '-';
    else if(profiles[index].status == "open" && profiles[index].applicationDeadline !=null) {
      String date = "Apply before " + formatDate(profiles[index].applicationDeadline!);
      return date;
    } else if (profiles[index].status == "withdrawable") {
      final title = profiles[index].application?.resume?.title ?? "";
      return title.isNotEmpty ? "$title Sent" : "Application Sent";
    }
    return ModelResources.analyseProfileStatus(profiles[index].status);
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
    await _deleteService.deleteApplicationService(applicationId);
    refresh();
  }
  
  Future<void> populateProfiles() async {
    setLoading();
    _profiles = await _applyService.fetchProfileForMe();
    setIdle();
  }
}