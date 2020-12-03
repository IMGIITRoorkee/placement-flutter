
import 'package:jiffy/jiffy.dart';
import 'package:placement/locator.dart';
import 'package:placement/models/profilesModel.dart';
import 'package:placement/resources/modelResources.dart';
import 'package:placement/services/generic/applyService.dart';
import 'package:placement/viewmodels/BaseViewModel.dart';

class ProfilesAppliedViewModel extends BaseViewModel {

  ApplyService _applyService = locator<ApplyService>();
  List<ProfilesModel> _profiles = [];
  bool _isLoading = false;
  bool _isDisposed = false;

  List<ProfilesModel> get profiles => _profiles;
  bool get isLoading => _isLoading;
  bool get isEmpty => (!_isLoading)&&(_profiles.length==0);

  @override
  void dispose() { 
    _isDisposed = true;
    super.dispose();
  }

  String formatDate(String it) {
    if(it == "") return "-";
    return Jiffy(it).yMMMd + " - " + Jiffy(it).Hm;
  }

  String profileStatus(int index) {
    if(_profiles[index].status == "locked") return _profiles[index].application.statusDisplayName;
    else if(_profiles[index].status == "open" && _profiles[index].applicationDeadline !=null) {
      String date = "Apply before " + formatDate(_profiles[index].applicationDeadline);
      return date;
    }
    else if(_profiles[index].status == "withdrawable") return _profiles[index].application.resume.title + " Sent";
    return ModelResources.analyseProfileStatus(_profiles[index].status);
  }

  void notif() {
    if(!_isDisposed) notifyListeners();
  }

  Future<void> fetchProfilesApplied() async {
    _isLoading = true;
    notif();
    _profiles = await _applyService.fetchProfileApplied();
    _isLoading = false;
    notif();
  }
}