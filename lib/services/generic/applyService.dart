import 'package:placement/locator.dart';
import 'package:placement/models/DetailCompanyProfileModel.dart';
import 'package:placement/models/candidateModel.dart';
import 'package:placement/models/profilesModel.dart';
import 'package:placement/models/resumeModel.dart';
import 'package:placement/resources/endpoints.dart';
import 'package:placement/services/generic/requestService.dart';
import 'package:placement/shared/GlobalCache.dart';

class ApplyService {
  final RequestService _requestService = locator<RequestService>();
  final GlobalCache _cache = locator<GlobalCache>();

  Future<DetailCompanyProfileModel?> fetchCompanyDetails(int profileId) async {
    var _data = await _requestService.makeGetRequest(
        EndPoints.HOST + EndPoints.PROFILES_ALL + profileId.toString() + '/');
    if (_data != -1 && _data != -2) {
      return DetailCompanyProfileModel.fromJson(_data);
    }
    return null;
  }

  Future<List<ProfilesModel>?> fetchProfileForMe() async {
    List<ProfilesModel> _list = [];
    if (_cache.profilesForMe == null) {
      var _data = await _requestService
          .makeGetRequest(EndPoints.HOST + EndPoints.PROFILES_ME);
      if (_data != -1 && _data != -2) {
        for (var p in _data) {
          _list.add(ProfilesModel.fromJson(p));
        }
        if (_list.length > 0) {
          _cache.profilesForMe = _list;
        }
      }
    }
    return _cache.profilesForMe;
  }

  Future<CandidateModel?> getCandidateProfile() async {
    if (_cache.candidateData == null) {
      var _data = await _requestService
          .makeGetRequest(EndPoints.HOST + EndPoints.CANDIDATE);

      if (_data != -1 && _data != -2) {
        CandidateModel candidate = CandidateModel.fromJson(_data);
        print("CANDI = $candidate");
        var _profilePic = await _requestService
            .makeGetRequest(EndPoints.HOST + EndPoints.WHOAMI);

        if (_profilePic != -1 && _profilePic != -2) {
          candidate.displayPicture =
              EndPoints.HOST + _profilePic['displayPicture'].toString();
        }
        print("CANDI PIC ${candidate.displayPicture}");
        _cache.candidateData = candidate;
      }
    }
    return _cache.candidateData;
  }

  Future<List<ProfilesModel>?> fetchProfileForAll() async {
    List<ProfilesModel> _list = [];
    if (_cache.profilesOpenForAll == null) {
      var _data = await _requestService
          .makeGetRequest(EndPoints.HOST + EndPoints.PROFILES_ALL);
      if (_data != -1 && _data != -2) {
        for (var p in _data) {
          _list.add(ProfilesModel.fromJson(p));
        }
        if (_list.length > 0) {
          _cache.profilesOpenForAll = _list;
        }
      }
    }
    return _cache.profilesOpenForAll;
  }

  Future<List<ProfilesModel>> fetchProfileApplied() async {
    List<ProfilesModel> _list = [];
    var _data = await _requestService
        .makeGetRequest(EndPoints.HOST + EndPoints.PROFILES_APPLIED);
    if (_data != -1 && _data != -2) {
      for (var p in _data) {
        _list.add(ProfilesModel.fromJson(p));
      }
    }
    return _list;
  }

  Future<List<ResumeModel>> fetchResumes() async {
    List<ResumeModel> _list = [];
    var _data = await _requestService
        .makeGetRequest(EndPoints.HOST + EndPoints.CANDIDATE_RESUME_LIST);
    if (_data != -1 && _data != -2) {
      for (var p in _data) {
        ResumeModel temp = ResumeModel.fromJson(p);
        var _resumeurl = await _requestService.makeGetRequest(EndPoints.HOST +
            EndPoints.RESUME_DETAIL +
            temp.id.toString() +
            '/');
        if (_resumeurl != -1 && _resumeurl != -2) {
          temp.resumeUrl = EndPoints.HOST + _resumeurl['resumeUrl'];
        }
        _list.add(temp);
      }
    }
    return _list;
  }
}
