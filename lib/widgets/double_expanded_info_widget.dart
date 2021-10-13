import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';

class DoubleExpandedInfoWidget extends StatelessWidget {
  Widget title1;
  Widget title2;
  Widget subtitle1;
  Widget subtitle2;

  DoubleExpandedInfoWidget(
      {required this.title1,
      required this.title2,
      required this.subtitle1,
      required this.subtitle2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [title1, SizedBox(height: 4,), subtitle1],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: 1,
            height: 30,
            color: primaryColor,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [title2, subtitle2],
          ),
        ),
      ],
    );
  }
}
