import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';

class TripleInfoWidget extends StatelessWidget {
  Widget title1;
  Widget title2;
  Widget title3;
  Widget subtitle1;
  Widget subtitle2;
  Widget subtitle3;
  VoidCallback? onThirdTap;
  VoidCallback? onSecondTap;

  TripleInfoWidget(
      {required this.title1,
      required this.title2,
      required this.title3,
      required this.subtitle1,
      required this.subtitle2,
      required this.subtitle3,
      this.onThirdTap, this.onSecondTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title1,
              SizedBox(
                height: 4,
              ),
              subtitle1
            ],
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
          child: onSecondTap == null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title2,
              SizedBox(
                height: 4,
              ),
              subtitle2
            ],
          )
              : InkWell(
            onTap: onSecondTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                title2,
                SizedBox(
                  height: 4,
                ),
                subtitle2
              ],
            ),
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
          child: onThirdTap == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    title3,
                    SizedBox(
                      height: 4,
                    ),
                    subtitle3
                  ],
                )
              : InkWell(
                  onTap: onThirdTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      title3,
                      SizedBox(
                        height: 4,
                      ),
                      subtitle3
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
