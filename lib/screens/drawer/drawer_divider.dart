import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';

class DrawerDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        color: primaryColor.withOpacity(1),
      ),
    );
  }
}
