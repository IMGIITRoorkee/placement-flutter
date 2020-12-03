import 'package:placement/locator.dart';
import 'package:placement/models/resumeModel.dart';
import 'package:placement/services/generic/applyService.dart';
import 'package:placement/viewmodels/BaseViewModel.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumeListViewModel extends BaseViewModel {

  List<ResumeModel> _resumes = [];
  ApplyService _applyService = locator<ApplyService>();

  List<ResumeModel> get resumes => _resumes;
  bool get isEmpty => (!isBusy) && (_resumes.length == 0);
  
  Future<void> getResumes() async {
    setLoading();
    _resumes = await _applyService.fetchResumes();
    setIdle();
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}