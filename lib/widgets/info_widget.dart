import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  String info;

  InfoWidget({required this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: primaryColor),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(info,
                style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w400,
                    color: textColor)),
          )
        ],
      ),
    );
  }
}
