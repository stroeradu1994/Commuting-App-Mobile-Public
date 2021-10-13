import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountWrapper extends StatelessWidget {
  List<Widget> children;
  String title;
  String image;
  Widget info;
  bool loading;
  bool isLogin;

  AccountWrapper(
      {required this.children,
      required this.title,
      required this.image,
      required this.info,
      this.loading = false,
      this.isLogin = false});

  @override
  Widget build(BuildContext context) {
    return MainScreen(
        hasBack: false,
        loading: loading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImage(),
            _buildTitle(),
            _buildSmallSpace(),
            _buildInfo(),
            _buildSpace(),
            ...children,
            SizedBox(height: 32),
            // Column(children: children),
          ],
        ),
        header: isLogin ? AppLocalizations.of(context)!.logIn : AppLocalizations.of(context)!.accountNewAccount);
  }

  _buildSpace() {
    return SizedBox(
      height: 32,
    );
  }

  _buildSmallSpace() {
    return SizedBox(
      height: 16,
    );
  }

  _buildImage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200,
        child: Center(
          child: SvgPicture.asset(
            image,
          ),
        ),
      ),
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Text(title,
            style: TextStyle(
                letterSpacing: 1,
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  Padding _buildInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: info,
      ),
    );
  }
}
