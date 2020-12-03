import 'package:placement/models/resultModel.dart';
import 'package:placement/models/yearModel.dart';

class ModelResources {

  static List<YearModel> yearOptions() {
    DateTime today = DateTime.now();
    int currentYr = today.year;
    if(today.month < 7) currentYr--;
    return [
      YearModel(key: 0,value: currentYr.toString()),
      YearModel(key: 1,value: (currentYr-1).toString()),
      YearModel(key: 2,value: (currentYr-2).toString()),
      YearModel(key: 3,value: (currentYr-3).toString()),
      YearModel(key: 4,value: (currentYr-4).toString()),
    ];
  }

  static String analyseProfileStatus(String code) {
    switch (code) {
      case "open": return "Open";
      case "candidate_ineligible": return "Ineligible";
      case "branch_not_eligible": return "Closed for your Branch";
      case "cgpa_not_eligible": return "Insufficient CGPA";
      case "expired": return "Application Closed";
      default: return "Closed";
    }
  }
  
  static final YEAR_OPTIONS = [
    YearModel(key: 0,value: "2019"),
    YearModel(key: 1,value: "2018"),
  ];

  static final RESULT_OPTIONS = [
    ResultModel(key: 0,value: "Placement "),
    ResultModel(key: 1,value: "Internship "),
  ];

  // YearModel can be used since we only need a key and a string object
  static final SORT_OPTIONS = [
    YearModel(key: 0,value: "Date Added"),
    YearModel(key: 1,value: "Alphabetically"),
  ];
}