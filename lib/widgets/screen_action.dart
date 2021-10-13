import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';

class ScreenAction extends StatelessWidget {
  List<ScreenActionItem> items;

  ScreenAction({required this.items});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      offset: Offset(-20, -20),
      icon: Icon(
        Icons.more_vert,
        color: primaryColor,
      ),
      onSelected: (int result) async {
        items[result].action();
      },
      itemBuilder: (BuildContext context) => items
          .map<PopupMenuItem<int>>((e) => PopupMenuItem<int>(
                value: items.indexOf(e),
                child: Text(e.text,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ))
          .toList(),
    );
  }
}

class ScreenActionItem {
  String text;
  VoidCallback action;

  ScreenActionItem(this.text, this.action);
}
