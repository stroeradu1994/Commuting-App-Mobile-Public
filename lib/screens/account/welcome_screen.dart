import 'package:commuting_app_mobile/screens/account/email_input.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScreen(
      hasBack: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          _buildInformationPanel(context),
          _buildActionButton(context),
        ],
      ),
    );
  }

  Padding _buildActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => EmailInput(false)),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
          ),
          child: Text(
            AppLocalizations.of(context)!.welcomeScreenStart,
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _buildInformationPanel(context) {
    return Column(
      children: [
        Container(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
                child: SvgPicture.asset(
                    'assets/images/undraw_city_driver_re_0x5e.svg')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Text(AppLocalizations.of(context)!.welcomeScreenTitle,
                style: TextStyle(
                    letterSpacing: 1,
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Center(
            child: Text(
                AppLocalizations.of(context)!.welcomeScreenSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: .8,
                    color: textColorShade1,
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
          ),
        )
      ],
    );
  }

  Padding _buildHeader(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => EmailInput(true)),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.logIn,
              style: TextStyle(
                  color: textColorShade1,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
