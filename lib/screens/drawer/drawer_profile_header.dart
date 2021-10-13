import 'package:commuting_app_mobile/provider/profile_provider.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/widgets/small_space_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var profileProvider = Provider.of<ProfileProvider>(context);

    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 32, bottom: 0),
      child: Column(
        children: [
          Row(
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
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.goodMorning + ',',
                      style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w400,
                          color: textColor)),
                  SizedBox(
                    height: 2,
                  ),
                  Text(profileProvider.profile!.firstName,
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          color: textColor)),
                ],
              )
            ],
          ),
          SmallSpaceWidget(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    profileProvider.profile!.points.toString(),
                    // style: TextStyle(
                    //     letterSpacing: 1,
                    //     color: textColor,
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(AppLocalizations.of(context)!.points),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(profileProvider.profile!.rating!.toStringAsFixed(1)),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.star_border,
                    size: 16,
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
