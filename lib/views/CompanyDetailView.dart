import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../models/DetailCompanyProfileModel.dart';
import '../resources/R.dart';
import '../screens/home/screens_for_apply/bottomModalApplySheet.dart';
import '../shared/loadingPage.dart';
import '../viewmodels/CompanyDetailViewModel.dart';
import 'baseView.dart';

class CompanyDetailView extends StatelessWidget {
  final dynamic args;
  const CompanyDetailView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;

    return BaseView<CompanyDetailViewModel>(
      onModelReady: (model) {
        model.fetchCompanyDetails(args['profileId']);
      },
      builder: (context, model, child) =>
          _companyDetailScaffold(context, model, _width),
    );
  }

  Widget _companyDetailScaffold(
      BuildContext context, CompanyDetailViewModel model, double _width) {
    final companyProfile = model.companyProfile;
    return ColoredBox(
      color: R.primaryCol,
      child: SafeArea(
        left: false,
        right: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Profile Details"),
          ),
          body: (model.isBusy || companyProfile == null)
              ? Center(
                  child: LoadingPage(),
                )
              : ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                        ),
                        _header(context, model, companyProfile, _width),
                        const SizedBox(
                          height: 20,
                        ),
                        _applyButton(context, model, companyProfile, _width),
                        const SizedBox(
                          height: 10,
                        ),
                        _description(context, companyProfile, _width),
                        const SizedBox(
                          height: 20,
                        ),
                        _eligibleBranches(context, companyProfile, _width),
                        const SizedBox(
                          height: 20,
                        ),
                        _profileDetail(context, model, companyProfile, _width),
                        const SizedBox(
                          height: 20,
                        ),
                        _packageDetail(context, model, companyProfile, _width),
                        const SizedBox(
                          height: 20,
                        ),
                        _roundSet(context, model, companyProfile, _width),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _roundSet(
      BuildContext context, CompanyDetailViewModel model, DetailCompanyProfileModel companyProfile, double _width) {
    int inx = 0;
    return (companyProfile.roundSet!.length == 0)
        ? const SizedBox.shrink()
        : SizedBox(
            width: _width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _sectionHeading("Process Details"),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: companyProfile.roundSet!.map((val) {
                    return _rowItem(
                        context,
                        val.name!,
                        Jiffy.parse(val.date!).toLocal().yMMMd + ", " + model.getTime(val.time!),
                        (inx++) % 2 == 0);
                  }).toList(),
                ),
              ],
            ),
          );
  }

  Widget _packageDetail(
      BuildContext context, CompanyDetailViewModel model,DetailCompanyProfileModel companyProfile, double _width) {
    return (model.checkOverallPackage())
        ? SizedBox(
            width: _width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _sectionHeading("Package Details"),
                _rowItemDual(
                    context,
                    "Under Graduate",
                    model.formatInt(companyProfile.packageCtcUg),
                    model.formatInt(companyProfile.packageBaseUg),
                    true,
                    visible: model.checkPackage("ug")),
                _rowItemDual(
                    context,
                    "Post Graduate",
                    model.formatInt(companyProfile.packageCtcPg),
                    model.formatInt(companyProfile.packageBasePg),
                    false,
                    visible: model.checkPackage("pg")),
                _rowItemDual(
                    context,
                    "PHd",
                    model.formatInt(companyProfile.packageCtcPhd),
                    model.formatInt(companyProfile.packageBasePhd),
                    true,
                    visible: model.checkPackage("phd")),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _profileDetail(
      BuildContext context, CompanyDetailViewModel model,DetailCompanyProfileModel companyProfile, double _width) {
    return SizedBox(
      width: _width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _sectionHeading("Profile Details"),
          const SizedBox(
            height: 5,
          ),
          _rowItem(context, "Profile Name",
              model.formatIt(companyProfile.name), true),
          _rowItem(context, "Profile Category",
              model.formatIt(companyProfile.category), false),
          _rowItem(context, "CGPA Requirement",
              model.formatIt(companyProfile.cgpaRequirement), true),
          _rowItem(context, "Description",
              model.formatIt(companyProfile.description), false),
          _rowItem(
              context, "Post", model.formatIt(companyProfile.post), true),
          _rowItem(context, "Posting Location",
              model.formatIt(companyProfile.location), false),
          _rowItem(context, "Package Description",
              model.formatIt(companyProfile.packageDescription), true),
          _rowItem(context, "Cover Letter Required",
              (companyProfile.requiresCoverLetter!) ? "Yes" : "No", false),
          _rowItem(context, "Target Credit Pool",
              model.formatIt(companyProfile.targetCreditPool), true),
          _rowItem(
              context,
              "PPT Presence Required",
              (companyProfile.talkPresenceRequired!) ? "Yes" : "No",
              false),
          _rowItem(context, "PPT Date",
              model.formatDate(companyProfile.talkDate), true),
          _rowItem(context, "PPT Absence Cost",
              companyProfile.talkAbsenceCost.toString(), false),
          _rowItem(context, "PPT Status",
              model.formatIt(companyProfile.talkStatus), true),
          _rowItem(
              context,
              "Application Deadline",
              model.formatDate(companyProfile.applicationDeadline),
              false),
          _rowItem(context, "Application Cost",
              companyProfile.applicationCost.toString(), true),
        ],
      ),
    );
  }

  Widget _rowItem(
      BuildContext context, String heading, String value, bool color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: (color) ? Colors.white : Color(0xFFf5f5f5),
          border: Border(
            bottom: BorderSide(width: 1.0, color: Color(0xFFe6e6e6)),
          )),
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

  Widget _rowItemDual(BuildContext context, String heading, String value1,
      String value2, bool color,
      {bool visible = true}) {
    return (visible)
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: (color) ? Colors.white : Color(0xFFf5f5f5),
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Color(0xFFe6e6e6)),
                )),
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
          )
        : const SizedBox.shrink();
  }

  Widget _eligibleBranches(
      BuildContext context, DetailCompanyProfileModel companyProfile, double _width) {
    return Container(
      width: _width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xFFe6f0ff),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Color(0xFFd9d9d9),
              offset: Offset(0.5, 0.5),
              blurRadius: 3.0,
              spreadRadius: 0.1)
        ],
      ),
      child: ExpansionTile(
        title: Text("View Eligible Branches"),
        children: companyProfile.branchRequirement!
            .map((val) => Container(
                  width: _width * 0.9,
                  padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                  child: Text(
                    val.name!,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(color: Color(0xFF666666)),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _description(
      BuildContext context, DetailCompanyProfileModel companyProfile, double _width) {
    return SizedBox(
      width: _width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _sectionHeading("Description"),
          Text(
            companyProfile.company!.description!,
            style: TextStyle(color: Color(0xFF666666)),
          )
        ],
      ),
    );
  }

  Widget _header(
      BuildContext context, CompanyDetailViewModel model, DetailCompanyProfileModel companyProfile, double _width) {
    return SizedBox(
      width: _width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            companyProfile.company!.name! +
                " (" +
                companyProfile.name! +
                ")",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
          Text(
            companyProfile.company!.sector!,
            style: TextStyle(color: Color(0xFF666666)),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Last Date of Application : ${model.formatDate(companyProfile.applicationDeadline)}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _sectionHeading(String heading) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        heading,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget _applyButton(
      BuildContext context, CompanyDetailViewModel model, DetailCompanyProfileModel companyProfile, double _width) {
    dynamic parentViewModel = args["parentViewModel"];
    dynamic profileModel = args["profileModel"];
    switch (companyProfile.profileStatus) {
      case 'branch_not_eligible':
        return InkWell(
          child: _buttonContainer(
              context,
              _width,
              "Branch not Eligible",
              Icon(
                Icons.highlight_off,
                color: Colors.red,
              )),
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => AlertDialog(
                      content:
                          Text("This Company is incompatible with you branch"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
          },
        );
      case 'expired':
        return InkWell(
          child: _buttonContainer(
              context,
              _width,
              "Expired",
              Icon(
                Icons.highlight_off,
                color: Colors.red,
              )),
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => AlertDialog(
                      content:
                          Text("This Deadline for application has expired"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
          },
        );
      case 'open':
        return InkWell(
          child: _buttonContainer(
              context,
              _width,
              "Apply",
              Icon(
                Icons.send,
                color: Colors.white,
              )),
          onTap: () async {
            bool? _didApply = await showModalBottomSheet<bool>(
                context: context,
                builder: (context) => BottomModalApplySheet(profile: profileModel));
              if (_didApply == true){
                parentViewModel.refresh();
                model.refreshDetails();
              }
          },
        );
      case 'withdrawable':
        return InkWell(
          child: _buttonContainer(
              context,
              _width,
              "Withdraw",
              Icon(
                Icons.undo,
                color: Colors.white,
              )),
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => AlertDialog(
                      content: Text(
                          "Do you wish to withdraw your resume from this Company?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Sure"),
                          onPressed: () async {
                            await parentViewModel.deleteApplication(
                                companyProfile.application.id);
                            model.refreshDetails();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          },
        );
      case 'locked':
        return InkWell(
          child: _buttonContainer(
              context,
              _width,
              "Locked",
              Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => AlertDialog(
                      content: Text("This Application has been locked"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
          },
        );
      default:
        return Icon(Icons.signal_cellular_connected_no_internet_4_bar);
    }
  }

  Widget _buttonContainer(
      BuildContext context, double _width, String display, Icon icon) {
    return Container(
      padding: EdgeInsets.all(10),
      width: _width * 0.65,
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
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 17),
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
