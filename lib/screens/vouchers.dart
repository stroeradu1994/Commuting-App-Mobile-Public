import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'common/main_screen_with_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Vouchers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScreenWithDrawer(
      position: 2,
      onRefresh: () async {
        return Future.value(true);
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              child: SvgPicture.asset(
                  'assets/images/undraw_Successful_purchase_re_mpig.svg'),
            ),
            SpaceWidget(),
            Text(AppLocalizations.of(context)!.noVouchers,
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 1,
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
