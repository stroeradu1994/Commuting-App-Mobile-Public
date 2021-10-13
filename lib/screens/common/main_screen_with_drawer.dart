import 'package:commuting_app_mobile/screens/drawer/drawer_divider.dart';
import 'package:commuting_app_mobile/screens/drawer/drawer_menu_item.dart';
import 'package:commuting_app_mobile/screens/drawer/drawer_profile_header.dart';
import 'package:commuting_app_mobile/screens/notification_screen.dart';
import 'package:commuting_app_mobile/screens/new_trip/new_trip.dart';
import 'package:commuting_app_mobile/screens/profile.dart';
import 'package:commuting_app_mobile/screens/statistics.dart';
import 'package:commuting_app_mobile/screens/vouchers.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../history.dart';
import '../trips.dart';
import 'main_screen.dart';

class MainScreenWithDrawer extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget child;
  Future<void> Function()? onRefresh;
  int position;

  MainScreenWithDrawer({required this.child, required this.position, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      onRefresh: onRefresh,
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          child,
        ],
      ),
      scaffoldKey: _scaffoldKey,
      hasBack: false,
      header: 'Commuting',
      action: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => NotificationScreen()),
          );
        },
        icon: Icon(Icons.notifications_none, color: primaryColor),
      ),
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: Icon(Icons.menu, color: primaryColor),
      ),
      floatingActionButton: position == 0 ? FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => NewTrip()),
          );
        },
      ) : null,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerProfileHeader(),
            DrawerDivider(),
            DrawerMenuItem(
              menuItem: AppLocalizations.of(context)!.trips,
              iconData: Icons.directions,
              onTap: () {
                changeScreen(context, Trips());
              },
              isSelected: position == 0,
            ),
            DrawerMenuItem(
              menuItem: AppLocalizations.of(context)!.history,
              iconData: Icons.timelapse,
              onTap: () {
                changeScreen(context, History());
              },
              isSelected: position == 1,
            ),
            DrawerDivider(),
            DrawerMenuItem(
              menuItem: AppLocalizations.of(context)!.vouchers,
              iconData: Icons.map_rounded,
              onTap: () {
                changeScreen(context, Vouchers());
              },
              isSelected: position == 2,
            ),
            DrawerMenuItem(
              menuItem: AppLocalizations.of(context)!.statistics,
              iconData: Icons.bar_chart,
              onTap: () {
                changeScreen(context, Statistics());
              },
              isSelected: position == 3,
            ),
            DrawerMenuItem(
              menuItem: AppLocalizations.of(context)!.profile,
              iconData: Icons.person_outline,
              onTap: () {
                changeScreen(context, Profile());
              },
              isSelected: position == 4,
            ),
            DrawerDivider(),
            DrawerMenuItem(
              menuItem: AppLocalizations.of(context)!.support,
              iconData: Icons.help_outline,
              onTap: () {
                changeScreen(context, Container());
              },
              isSelected: position == 5,
            ),
            DrawerMenuItem(
              menuItem: AppLocalizations.of(context)!.about,
              iconData: Icons.info_outline,
              onTap: () {
                changeScreen(context, Container());
              },
              isSelected: position == 6,
            ),
          ],
        ),
      ),
    );
  }

  changeScreen(context, Widget child) {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
          builder: (context) => child),
    );
  }
}
