import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';

class CommonAppbar extends StatelessWidget {
  final Widget? action;
  final Widget? leading;
  final String title;

  CommonAppbar({required this.title, this.leading, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leading == null
              ? IconButton(
                  icon: Icon(
                    null,
                    color: primaryColor,
                  ),
                  onPressed: null)
              : leading!,
          Text(
            title,
            style: TextStyle(
                fontSize: 18,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
                color: textColor),
          ),
          action == null
              ? IconButton(
                  icon: Icon(
                    null,
                    color: primaryColor,
                  ),
                  onPressed: null)
              : action!,
        ],
      ),
    );
  }
}
