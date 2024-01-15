import 'package:placement/locator.dart';
import 'package:placement/models/candidateModel.dart';
import 'package:placement/services/auth/auth_service.dart';
import 'package:placement/services/generic/applyService.dart';
import 'package:placement/viewmodels/BaseViewModel.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CandidateDetailsViewModel extends BaseViewModel {
  ApplyService _applyService = locator<ApplyService>();
  CandidateModel? _candidate;
  AuthService _auth = AuthService();
  CandidateModel? get candidate => _candidate;

  Future<void> fetchCandidate() async {
    setLoading();
    _candidate = await _applyService.getCandidateProfile();
    setIdle();
  }

  Future<void> launchURL(String url) async {
    try {
      await launchUrlString(url);
    } catch (e) {
      print('Error launching URL: $e');
      throw 'Could not launch $url';
    }
  }

  Future<void> logout() async {
    await _auth.logOut();
  }
}
