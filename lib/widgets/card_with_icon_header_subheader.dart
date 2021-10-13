import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';

class CardWithIconHeaderSubheader extends StatelessWidget {
  IconData icon;
  String header;
  String? subheader;
  bool showFullSubheader = false;
  Function? onTap;
  Widget? trailingButton;

  CardWithIconHeaderSubheader(
      this.icon, this.header, this.subheader, this.onTap, this.trailingButton, {this.showFullSubheader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: InkWell(
          onTap: () => onTap!(),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(header,
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: textColor)),
                      subheader == null ? SizedBox.shrink() : SizedBox(
                        height: 1,
                      ),
                      subheader == null ? SizedBox.shrink() : Text(subheader!,
                          overflow: showFullSubheader ? TextOverflow.visible : TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w300,
                              color: textColor)),
                    ],
                  ),
                ),
                trailingButton == null ? SizedBox.shrink() : trailingButton!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
