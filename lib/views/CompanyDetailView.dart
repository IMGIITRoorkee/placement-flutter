import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:placement/screens/home/screens_for_apply/bottomModalApplySheet.dart';
import 'package:placement/shared/hexColor.dart';
import 'package:placement/shared/loadingPage.dart';
import 'package:placement/viewmodels/CompanyDetailViewModel.dart';
import 'package:placement/views/baseView.dart';

class CompanyDetailView extends StatelessWidget {
  final Map<String, dynamic> args;
  const CompanyDetailView({Key key, this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final double _width = MediaQuery.of(context).size.width;

    return BaseView<CompanyDetailViewModel>(
      onModelReady: (model) {
        model.fetchCompanyDetails(args['profileId']);
      },
      builder: (context, model, child) => _companyDetailScaffold(context, model, _width),
    );
  }

  Widget _companyDetailScaffold(BuildContext context, CompanyDetailViewModel model, double _width) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Details"),
      ),
      body: (model.isLoading) ? Center(
        child: LoadingPage(),
      ) 
      : Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 30,),
              _header(context, model, _width),
              SizedBox(height: 20,),
              _applyButton(context, model, _width),
              SizedBox(height: 10,),
              _description(context, model, _width),
              SizedBox(height: 20,),
              _eligibleBranches(context, model, _width),
              SizedBox(height: 20,),
              _profileDetail(context, model, _width),
              SizedBox(height: 20,),
              _packageDetail(context, model, _width),
              SizedBox(height: 20,),
              _roundSet(context, model, _width),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundSet(BuildContext context, CompanyDetailViewModel model, double _width) {
    int inx = 0;
    return (model.companyProfile.roundSet.length == 0) ?
    Container() :
    Container(
      width: _width*0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _sectionHeading("Process Details"),
          SizedBox(height: 5,),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: model.companyProfile.roundSet.map(
              (val) {
                return _rowItem(context, val.name, Jiffy(val.date).yMMMd + ", " + model.getTime(val.time), (inx++)%2==0);
              }
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _packageDetail(BuildContext context, CompanyDetailViewModel model, double _width) {
    return (model.checkOverallPackage()) ? 
    Container(
      width: _width*0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _sectionHeading("Package Details"),
          _rowItemDual(
            context,
            "Under Graduate", 
            model.formatInt(model.companyProfile.packageCtcUg), 
            model.formatInt(model.companyProfile.packageBaseUg),
            true,
            visible: model.checkPackage("ug")
          ),
          _rowItemDual(
            context,
            "Post Graduate", 
            model.formatInt(model.companyProfile.packageCtcPg), 
            model.formatInt(model.companyProfile.packageBasePg),
            false,
            visible: model.checkPackage("pg")
          ),
          _rowItemDual(
            context,
            "PHd", 
            model.formatInt(model.companyProfile.packageCtcPhd), 
            model.formatInt(model.companyProfile.packageBasePhd),
            true,
            visible: model.checkPackage("phd")
          ),
        ],
      ),
    ) :
    Container();
  }

  Widget _profileDetail(BuildContext context, CompanyDetailViewModel model, double _width) {
    print("REBUILD!! + ${model.companyProfile.packageDescription.toString()}");
    return Container(
      width: _width*0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _sectionHeading("Profile Details"),
          SizedBox(height: 5,),
          _rowItem(context, "Profile Name", model.formatIt(model.companyProfile.name), true),
          _rowItem(context, "Profile Category", model.formatIt(model.companyProfile.category), false),
          _rowItem(context, "CGPA Requirement", model.formatIt(model.companyProfile.cgpaRequirement), true),
          _rowItem(context, "Description", model.formatIt(model.companyProfile.description), false),
          _rowItem(context, "Post", model.formatIt(model.companyProfile.post), true),
          _rowItem(context, "Posting Location", model.formatIt(model.companyProfile.location), false),
          _rowItem(context, "Package Description", model.formatIt(model.companyProfile.packageDescription), true),
          _rowItem(context, "Cover Letter Required", (model.companyProfile.requiresCoverLetter) ? "Yes" : "No", false),
          _rowItem(context, "Target Credit Pool", model.formatIt(model.companyProfile.targetCreditPool), true),
          _rowItem(context, "PPT Presence Required", (model.companyProfile.talkPresenceRequired) ? "Yes" : "No", false),
          _rowItem(context, "PPT Date",model.formatDate(model.companyProfile.talkDate), true),
          _rowItem(context, "PPT Absence Cost", model.companyProfile.talkAbsenceCost.toString(), false),
          _rowItem(context, "PPT Status", model.formatIt(model.companyProfile.talkStatus), true),
          _rowItem(context, "Application Deadline", model.formatDate(model.companyProfile.applicationDeadline), false),
          _rowItem(context, "Application Cost", model.companyProfile.applicationCost.toString(), true),
        ],
      ),
    );
  }

  Widget _rowItem(BuildContext context, String heading, String value, bool color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: (color) ? Colors.white : HexColor("#f5f5f5"),
        border: Border(
          bottom: BorderSide(width: 1.0, color: HexColor("#e6e6e6")),
        )
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(heading),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowItemDual(BuildContext context, String heading, String value1, String value2, bool color, {bool visible = true}) {
    return (visible) ? 
    Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: (color) ? Colors.white : HexColor("#f5f5f5"),
        border: Border(
          bottom: BorderSide(width: 1.0, color: HexColor("#e6e6e6")),
        )
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(heading),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(value1),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(value2),
            ),
          ),
        ],
      ),
    ) :
    Container();
  }

  Widget _eligibleBranches(BuildContext context, CompanyDetailViewModel model, double _width) {
    return Container(
      width: _width*0.9,
      decoration: BoxDecoration(
        color: HexColor("#e6f0ff"),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: HexColor("#d9d9d9"), offset: Offset(0.5, 0.5), blurRadius: 3.0, spreadRadius: 0.1)],
      ),
      child: ExpansionTile(
        title: Text("View Eligible Branches"),
        children: model.companyProfile.branchRequirement.map(
          (val) => Container(
            width: _width*0.9,
            padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
            child: Text(
              val.name,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: HexColor("#666666")
              ),
            ),
          )
        ).toList(),
      ),
    );
  }

  Widget _description(BuildContext context, CompanyDetailViewModel model, double _width) {
    return Container(
      width: _width*0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _sectionHeading("Description"),
          Text(
            model.companyProfile.company.description,
            style: TextStyle(
              color: HexColor("#666666")
            ),
          )
        ],
      ),
    );
  }

  Widget _header(BuildContext context, CompanyDetailViewModel model, double _width) {
    return Container(
      width: _width*0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            model.companyProfile.company.name + " (" + model.companyProfile.name + ")",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23
            ),
          ),
          Text(
            model.companyProfile.company.sector,
            style: TextStyle(
              color: HexColor("#666666")
            ),
          ),
          SizedBox(height: 20,),
          Text(
            "Last Date of Application : ${model.formatDate(model.companyProfile.applicationDeadline)}",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }

  Widget _sectionHeading(String heading) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        heading,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20
        ),
      ),
    );
  }

  Widget _applyButton(BuildContext context, CompanyDetailViewModel model, double _width) {
    dynamic parentViewModel = args["parentViewModel"];
    dynamic profileModel = args["profileModel"];
    switch (model.companyProfile.profileStatus) {
      case 'branch_not_eligible':
        return InkWell(
          child: _buttonContainer(context, _width, "Branch not Eligible",  Icon(Icons.highlight_off, color: Colors.red,)),
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                content: Text("This Company is incompatible with you branch"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ], 
              )
            );
          },
        );
        break;
      case 'expired':
        return InkWell(
          child: _buttonContainer(context, _width, "Expired",  Icon(Icons.highlight_off, color: Colors.red,)),
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                content: Text("This Deadline for application has expired"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ], 
              )
            );
          },
        );
        break;
      case 'open':
        return InkWell(
          child: _buttonContainer(context, _width, "Apply",  Icon(Icons.send, color: Colors.white,)),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return BottomModalApplySheet(
                  profile: profileModel,
                );
              }
            ).then((value) {
              print("APPLIED!!");
              parentViewModel.refresh();
              model.refreshDetails();
            });
          },
        );
        break;
      case 'withdrawable':
        return InkWell(
          child: _buttonContainer(context, _width, "Withdraw",  Icon(Icons.undo, color: Colors.white,)),
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                content: Text("Do you wish to withdraw your resume from this Company?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Sure"),
                    onPressed: () async {
                      await parentViewModel.deleteApplication(model.companyProfile.application.id);
                      model.refreshDetails();
                      Navigator.of(context).pop();
                    },
                  ),
                ], 
              )
            );
          },
        );
        break;
      case 'locked':
      return InkWell(
          child: _buttonContainer(context, _width, "Locked",  Icon(Icons.lock, color: Colors.grey,)),
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                content: Text("This Application has been locked"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ], 
              )
            );
          },
        );
        break;
      default:return Icon(Icons.signal_cellular_connected_no_internet_4_bar);
    }
  }

  Widget _buttonContainer(BuildContext context, double _width, String display, Icon icon) {
    return Container(
      padding: EdgeInsets.all(10),
      width: _width*0.65,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                display,
                style: TextStyle(
                  color: HexColor("#FFFFFF"),
                  fontSize: 17
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: icon,
          ),
        ],
      ),
    );
  }
}