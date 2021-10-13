import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommonHeader extends StatelessWidget {
  String header;
  bool withPadding = true;

  CommonHeader({required this.header, this.withPadding = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: withPadding ? const EdgeInsets.symmetric(horizontal: 26.0) : EdgeInsets.zero,
      child: Text(
        header,
        style: TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
            color: textColor),
      ),
    );
  }
}
