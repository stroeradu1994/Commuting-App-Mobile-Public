import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';

class IconWithTextWidget extends StatelessWidget {
  IconData icon;
  String text;
  String? subtext;

  IconWithTextWidget({required this.text, required this.icon, this.subtext});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(
          icon,
          color: primaryColor,
        ),
        SizedBox(
          width: 14,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(text,
                  style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w400,
                      color: textColor)),
              if (subtext != null )             Text(subtext!,
                  style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w400,
                      color: textColor))
            ],
          ),
        ),
      ],
    );
  }
}
