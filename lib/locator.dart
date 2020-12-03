
import 'package:get_it/get_it.dart';
import 'package:placement/services/generic/applyService.dart';
import 'package:placement/services/generic/calendarService.dart';
import 'package:placement/services/generic/resultService.dart';
import 'package:placement/shared/GlobalCache.dart';
import 'package:placement/viewmodels/CalendarViewModel.dart';
import 'package:placement/services/generic/requestService.dart';
import 'package:placement/viewmodels/CandidateDetailsViewModel.dart';
import 'package:placement/viewmodels/CompanyDetailViewModel.dart';
import 'package:placement/viewmodels/ProfilesAppliedViewModel.dart';
import 'package:placement/viewmodels/ProfilesForAllViewModel.dart';
import 'package:placement/viewmodels/ProfilesForMeViewModel.dart';
import 'package:placement/viewmodels/ResultPageViewModel.dart';
import 'package:placement/viewmodels/ResultsBranchWiseViewModel.dart';
import 'package:placement/viewmodels/ResultsCompanyWiseViewModel.dart';
import 'package:placement/viewmodels/ResumeListViewModel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  
  locator.registerLazySingleton(() => RequestService());
  locator.registerLazySingleton(() => CalendarService());
  locator.registerLazySingleton(() => ResultService());
  locator.registerLazySingleton(() => ApplyService());
  locator.registerLazySingleton(() => GlobalCache());

  locator.registerFactory(() => CalendarViewModel());
  locator.registerFactory(() => ResultPageViewModel());
  locator.registerFactory(() => ResultsBranchWiseViewModel());
  locator.registerFactory(() => ResultsCompanyWiseViewModel());
  locator.registerFactory(() => ProfilesForMeViewModel());
  locator.registerFactory(() => ProfilesForAllViewModel());
  locator.registerFactory(() => CompanyDetailViewModel());
  locator.registerFactory(() => ProfilesAppliedViewModel());
  locator.registerFactory(() => ResumeListViewModel());
  locator.registerFactory(() => CandidateDetailsViewModel());
  
}