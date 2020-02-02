import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:placement/screens/home/homePage.dart';
import 'package:placement/screens/home/screens_for_apply/screens_for_result_details/resultDetailsBranchWise.dart';
import 'package:placement/screens/home/screens_for_result_details/resultDetailsCompanyWise.dart';
import 'package:placement/screens/splash/splash.dart';
import 'package:placement/screens/wrapper.dart';

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
        return MaterialPageRoute(
          builder: (_) => ResultDetailsBranchWise()
        );
      break;
      case '/result_details_companywise':
        return MaterialPageRoute(
          builder: (_) => ResultDetailsCompanyWise()
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