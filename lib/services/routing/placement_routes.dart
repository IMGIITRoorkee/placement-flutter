import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:placement/screens/home/homePage.dart';
import 'package:placement/screens/home/profilePage.dart';
import 'package:placement/screens/home/screens_for_result_details/resultDetailsBranchWise.dart';
import 'package:placement/screens/home/screens_for_result_details/resultDetailsCompanyWise.dart';
import 'package:placement/screens/notifications/notificationsScreen.dart';
import 'package:placement/screens/splash/splash.dart';
import 'package:placement/screens/wrapper.dart';
import 'package:placement/views/CompanyDetailView.dart';
import 'package:placement/views/ProfilesAppliedView.dart';
import 'package:placement/views/ResumeListView.dart';

class RouteGeneratorPlacement {
  static Route<dynamic> getRoutes(RouteSettings settings) {

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => SplashPage()
        );
        break;
      case '/wrapper':
        return MaterialPageRoute(
          builder: (_) => WrapperPage()
        );
      break;
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomePage()    
        );
      break;
      case '/result_details_branchwise':
      var _resultArgs = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => ResultDetailsBranchWise(args: _resultArgs,)
        );
      break;
      case '/result_details_companywise':
      var _resultArgs = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => ResultDetailsCompanyWise(args: _resultArgs,)
        );
      break;
      case '/notifs':
        return MaterialPageRoute(
          builder: (_) => NotificationsScreen()
        );
      break;
      case '/profileDetail':
        var _profileArgs = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => CompanyDetailView(args: _profileArgs)
        );
      break;
      case '/profileApplied':
        return MaterialPageRoute(
          builder: (_) => ProfilesAppliedView()
        );
      break;
      case '/resumes':
        return MaterialPageRoute(
          builder: (_) => ResumeListView()
        );
      break;
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('Error has occurred'),
            ),
          )
        );
    }
  }
}