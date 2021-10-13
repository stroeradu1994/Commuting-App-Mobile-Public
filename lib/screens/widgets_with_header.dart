import 'package:commuting_app_mobile/widgets/trip_card.dart';
import 'package:flutter/material.dart';

import 'common/common_header.dart';

class WidgetsWithHeader extends StatelessWidget {

  String header;
  List<Widget> widgets;


  WidgetsWithHeader({required this.header, required this.widgets});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CommonHeader(
          header: header,
        ),
        SizedBox(
          height: 16,
        ),
        ...widgets,
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
