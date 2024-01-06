import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:placement/resources/R.dart';
import 'package:placement/resources/strings.dart';
import 'package:placement/shared/hexColor.dart';
import 'package:placement/shared/loadingPage.dart';
import 'package:placement/viewmodels/CandidateDetailsViewModel.dart';
import 'package:placement/views/baseView.dart';

class CandidateDetailsView extends StatelessWidget {
  const CandidateDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;

    return BaseView<CandidateDetailsViewModel>(
      onModelReady: (model) {
        model.fetchCandidate();
      },
      builder: (context, model, child) =>
          _detailScaffold(context, model, _width),
    );
  }

  Widget _detailScaffold(
      BuildContext context, CandidateDetailsViewModel model, double _width) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: (model.isBusy)
            ? Center(
                child: LoadingPage(),
              )
            : (model.candidate == null)
                ? _errorColumn(context, model, _width)
                : _profileBody(context, model, _width),
      ),
    );
  }

  Widget _errorColumn(
      BuildContext context, CandidateDetailsViewModel model, double _width) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text("Something went Wrong"),
          ),
          SizedBox(
            height: 20,
          ),
          _menu(context, model, _width),
        ],
      ),
    );
  }

  Widget _profileBody(BuildContext context, dynamic model, double _width) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          _headerAndIcon(context, model.candidate, _width),
          SizedBox(
            height: 20,
          ),
          _studentInfo(context, model.candidate, _width),
          SizedBox(
            height: 20,
          ),
          _myApplicationsButton(context, model.candidate, _width),
          SizedBox(
            height: 20,
          ),
          _myResumesButton(context, model.candidate, _width),
          SizedBox(
            height: 20,
          ),
          _menu(context, model, _width),
        ],
      ),
    );
  }

  Widget _menu(BuildContext context, dynamic model, double _width) {
    return Container(
      width: _width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            leading: Icon(Icons.help_outline),
            title: Text(
              "FAQs",
              style: TextStyle(color: R.textColPrimary),
            ),
            onTap: () {
              model.launchURL(Strings.FAQ_LINK);
            },
          ),
          _divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            leading: Icon(Icons.info),
            title: Text(
              "About Us",
              style: TextStyle(color: R.textColPrimary),
            ),
            onTap: () {
              model.launchURL(Strings.ABOUT_US_LINK);
            },
          ),
          _divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 5),
            leading: Icon(Icons.exit_to_app),
            title: Text(
              "Log Out",
              style: TextStyle(color: R.textColPrimary),
            ),
            onTap: () async {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                        content: Text("Do you wish to Log out?"),
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
                              await model.logout();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/wrapper', (Route<dynamic> route) => false);
                            },
                          ),
                        ],
                      ));
            },
          ),
          _divider(),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Color(0xFFe6e6e6),
      thickness: 1,
      indent: 10,
      height: 0,
      endIndent: 10,
    );
  }

  Widget _myApplicationsButton(
      BuildContext context, dynamic model, double _width) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/profileApplied');
      },
      child: _button("My Applications", _width),
    );
  }

  Widget _myResumesButton(BuildContext context, dynamic model, double _width) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/resumes');
      },
      child: _button("My Resumes", _width),
    );
  }

  Widget _button(String heading, double _width) {
    return Container(
      width: _width * 0.9,
      decoration: BoxDecoration(
          color: Color(0xFF73A1FD).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                heading,
                style: TextStyle(color: Color(0xFF878787), fontSize: 17),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF73A1FD),
            ),
          ),
        ],
      ),
    );
  }

  Widget _studentInfo(BuildContext context, dynamic model, double _width) {
    return Container(
      width: _width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            model.degreeName,
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            model.departmentName,
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 10,
          ),
          _statusRows("Status: ", model.season + ", " + model.internshipStatus),
          SizedBox(
            height: 5,
          ),
          _statusRows("Pool A Credits: ", model.creditsPoolA.toString()),
          SizedBox(
            height: 5,
          ),
          _statusRows("Pool B Credits: ", model.creditsPoolB.toString()),
        ],
      ),
    );
  }

  Widget _statusRows(String heading, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          heading,
          style: TextStyle(fontSize: 17, color: R.textColPrimary),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _headerAndIcon(BuildContext context, dynamic model, double _width) {
    return Container(
      width: _width * 0.9,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey[300], shape: BoxShape.circle),
                  child: Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (model.displayPicture != "https://channeli.innull")
                  CachedNetworkImage(
                    imageUrl: model.displayPicture,
                    placeholder: _imagePlaceHolder,
                    imageBuilder: (context, imageProvider) {
                      return CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 30,
                      );
                    },
                  ),
              ],
            ),
          ),
          // Container(
          //   width: 60,
          //   height: 60,
          //   decoration: BoxDecoration(
          //     color: Colors.red,
          //     shape: BoxShape.circle,
          //     image: DecorationImage(
          //       image:
          //     )
          //   ),
          //   child: (model.displayPicture != null) ?
          //   CachedNetworkImage(
          //     imageUrl: model.displayPicture,
          //     placeholder: _imagePlaceHolder,
          //     imageBuilder: (context, imageProvider) {
          //       return CircleAvatar(
          //         backgroundImage: imageProvider,
          //         radius: 30,
          //       );
          //     },
          //   ) :
          //   _imagePlaceHolder(context, ""),
          // ),
          SizedBox(
            width: 10,
          ),
          Text(
            model.candidateName,
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceHolder(BuildContext context, String str) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey[300],
      child: Icon(
        Icons.account_circle,
        size: 60,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
