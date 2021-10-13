import 'package:commuting_app_mobile/dto/profile/profile_response.dart';
import 'package:commuting_app_mobile/provider/profile_provider.dart';
import 'package:commuting_app_mobile/screens/account/welcome_screen.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/profile_service.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/widgets/double_info_widget.dart';
import 'package:commuting_app_mobile/widgets/loading_widget.dart';
import 'package:commuting_app_mobile/widgets/small_space_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'common/main_screen_with_drawer.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var tokenService = locator.get<TokenService>();

  @override
  Widget build(BuildContext context) {
    var profileProvider = Provider.of<ProfileProvider>(context);

    return MainScreenWithDrawer(
      position: 4,
      onRefresh: () async {
        await profileProvider.getProfile();
        return Future.value(true);
      },
      child: _buildWrapper(profileProvider),
    );
  }

  Widget _buildWrapper(ProfileProvider profileProvider) {
    if (profileProvider.state == ProfileProviderState.NOT_FETCHED) {
      profileProvider.getProfile();
    }
    if (profileProvider.state == ProfileProviderState.IDLE) {
      return _buildContent(profileProvider.profile!);
    }
    return LoadingWidget();
  }

  Widget _buildContent(ProfileResponse profileResponse) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8, right: 8),
            child: _buildHeader(profileResponse),
          ),
          Divider(),
          SmallSpaceWidget(),
          _buildPointsRating(profileResponse),
          SmallSpaceWidget(),
          Divider(),
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text(AppLocalizations.of(context)!.locations),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text(AppLocalizations.of(context)!.cars),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text(profileResponse.email!),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(profileResponse.phone!),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );
  }

  Container _buildPointsRating(ProfileResponse profileResponse) {
    return Container(
          height: 50,
          child: DoubleInfoWidget(
              title1: Text(profileResponse.points!.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w400,
                      color: textColor)),
              title2: Text(profileResponse.rating!.toStringAsFixed(1),
                  style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w400,
                      color: textColor)),
              subtitle1: Text(AppLocalizations.of(context)!.pointsCaps,
                  style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w400,
                      color: textColor)),
              subtitle2: Text(AppLocalizations.of(context)!.rating,
                  style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w400,
                      color: textColor))),
        );
  }

  Widget _buildHeader(ProfileResponse profileResponse) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
          radius: 20,
          backgroundColor: Colors.blueGrey,
        ),
        SizedBox(
          width: 24,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(profileResponse.firstName + ' ' + profileResponse.lastName,
                style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    color: textColor)),
          ],
        )
      ],
    );
  }

  _buildLogout() {
    return TextButton(
        onPressed: () {
          tokenService.deleteTokens();
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => WelcomeScreen()),
          );
        },
        child: Text(AppLocalizations.of(context)!.logout));
  }
}

/*
          TextButton(
              onPressed: () {
                tokenService.deleteTokens();
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              child: Text('Logout'))
 */
