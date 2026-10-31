import 'package:flutter/material.dart';
import 'package:placement/screens/acknowledgement/acknowledgementScreen.dart';
import 'package:placement/screens/home/homePage.dart';
import 'package:placement/screens/home/screens_for_result_details/resultDetailsBranchWise.dart';
import 'package:placement/screens/home/screens_for_result_details/resultDetailsCompanyWise.dart';
import 'package:placement/screens/notifications/notificationsScreen.dart';
import 'package:placement/screens/splash/splash.dart';
import 'package:placement/screens/wrapper.dart';
import 'package:placement/services/generic/acknowledgementService.dart';
import 'package:placement/views/CompanyDetailView.dart';
import 'package:placement/views/ProfilesAppliedView.dart';
import 'package:placement/views/ResumeListView.dart';

class RouteGeneratorPlacement {
  static Route<dynamic> getRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case '/wrapper':
        return MaterialPageRoute(builder: (_) => WrapperPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/result_details_branchwise':
        Object? _resultArgs = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => ResultDetailsBranchWise(
                  args: _resultArgs,
                ));
      case '/result_details_companywise':
        Object? _resultArgs = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => ResultDetailsCompanyWise(
                  args: _resultArgs,
                ));
      case AcknowledgementService.ROUTE:
        return MaterialPageRoute(builder: (_) => AcknowledgementScreen());
      case '/notifs':
        return MaterialPageRoute(builder: (_) => NotificationsScreen());
      case '/profileDetail':
        Object? _profileArgs = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => CompanyDetailView(args: _profileArgs));
      case '/profileApplied':
        return MaterialPageRoute(builder: (_) => ProfilesAppliedView());
      case '/resumes':
        return MaterialPageRoute(builder: (_) => ResumeListView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('Error has occurred'),
            ),
          ),
        );
    }
  }
}
