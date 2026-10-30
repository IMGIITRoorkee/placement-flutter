import 'package:flutter/material.dart';

import '../shared/ErrorWidget.dart';
import '../shared/ProfileStatusIcon.dart';
import '../shared/loadingPage.dart';
import '../viewmodels/ProfilesForAllViewModel.dart';
import 'baseView.dart';

class ProfilesForAllView extends StatelessWidget {
  const ProfilesForAllView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfilesForAllViewModel>(
      onModelReady: (model) {
        model.populateProfiles();
      },
      builder: (context, model, child) => _applyWidget(context, model),
    );
  }

  Widget _applyWidget(BuildContext context, ProfilesForAllViewModel model) {
    if (model.isBusy)
      return Center(
        child: LoadingPage(),
      );
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: _applyList(context, model),
    );
  }

  Widget _applyList(BuildContext context, ProfilesForAllViewModel model) {
    final profiles = model.profiles;
    if (profiles == null) {
      return ErrorWidgetWithRefreshCallback(onRefresh: model.refreshAndWait);
    }
    if (profiles.isEmpty) {
      return Center(child: Text("No companies open right now"),);
    }
    return RefreshIndicator(
      onRefresh: model.refreshAndWait,
      child: ListView.builder(
        itemCount: profiles.length,
        padding: EdgeInsets.all(5),
        itemBuilder: (BuildContext context, int index) {
          return Card(
              margin: EdgeInsets.only(bottom: 1),
              elevation: 0.3,
              child: ListTile(
                title: Text(
                  profiles[index].companyName +
                      "(" +
                      profiles[index].name +
                      ")",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, height: 1.1, fontSize: 15),
                ),
                subtitle: Text(
                  "Status: " + model.profileStatus(index),
                  style: TextStyle(
                    height: 1.85,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed("/profileDetail", arguments: {
                    "profileId": profiles[index].profileId,
                    "parentViewModel": model,
                    "profileModel": profiles[index]
                  });
                },
                //trailing: _profileStatusIcon(context,model.profiles[index].status,model.profiles[index])
                trailing: ProfileStatusIcon(
                  model: model,
                  profile: profiles[index],
                  status: profiles[index].status,
                ),
              ));
        },
      ),
    );
  }
}
