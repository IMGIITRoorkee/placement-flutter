import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:placement/shared/ProfileStatusIcon.dart';
import 'package:placement/shared/loadingPage.dart';
import 'package:placement/viewmodels/ProfilesForMeViewModel.dart';
import 'package:placement/views/baseView.dart';

class ProfilesForMeView extends StatelessWidget {
  const ProfilesForMeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfilesForMeViewModel>(
      onModelReady: (model) {
        model.populateProfiles();
      },
      builder: (context, model, child) => _applyWidget(context, model),
    );
  }

  Widget _applyWidget(BuildContext context, ProfilesForMeViewModel model) {
    if(model.isLoading) return Center(
      child: LoadingPage(),
    );
    return Container(
      constraints: BoxConstraints.expand(),
      child: _applyList(context, model),
    );
  }

  Widget _applyList(BuildContext context, ProfilesForMeViewModel model) {
    if(model.isNull) return Center(
      child: Text("Not Eligible for any Active season"),
    );
    return RefreshIndicator(
      onRefresh: model.refreshAndWait,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: model.profiles.length,
        padding: EdgeInsets.all(5),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.only(bottom: 1),
            elevation: 0.3,
            child: ListTile(
              title: Text(
                model.profiles[index].companyName + " (" + model.profiles[index].name + ")",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  fontSize: 15
                ),
              ),
              subtitle: Text(
                "Status: " + model.profileStatus(index),
                style: TextStyle(
                  height: 1.85,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(
                  "/profileDetail",
                  arguments: {
                    "profileId" : model.profiles[index].profileId,
                    "parentViewModel" : model,
                    "profileModel" : model.profiles[index]
                  }
                );
              },
              //trailing: _profileStatusIcon(context,model.profiles[index].status,model.profiles[index])
              trailing: ProfileStatusIcon(
                model: model,
                profile: model.profiles[index],
                status: model.profiles[index].status,
              ),
            )
          );
        },
      ),
    );
  }
}