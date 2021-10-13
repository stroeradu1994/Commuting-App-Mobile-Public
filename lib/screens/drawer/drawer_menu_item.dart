import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  String menuItem;
  IconData iconData;
  Function onTap;
  bool isSelected;

  DrawerMenuItem({required this.menuItem, required this.iconData, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              iconData,
              color: primaryColor,
            ),
            SizedBox(
              width: 16,
            ),
            Text(menuItem,
                style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 1,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: textColor))
          ],
        ),
      ),
    );
  }
}
