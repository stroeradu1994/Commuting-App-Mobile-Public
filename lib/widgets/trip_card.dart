import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/widgets/small_space_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:commuting_app_mobile/widgets/trip_locations_widget.dart';
import 'package:commuting_app_mobile/widgets/info_widget.dart';

class TripCard extends StatelessWidget {
  int type;
  String time;
  String fromLabel;
  String fromAddress;
  String toLabel;
  String toAddress;
  List<String> info;
  Widget navigateTo;
  String? actionText;
  VoidCallback? action;
  VoidCallback? onDelete;

  TripCard(
      {required this.type,
      required this.time,
      required this.fromLabel,
      required this.fromAddress,
      required this.toLabel,
      required this.toAddress,
      required this.info,
      required this.navigateTo,
      this.actionText,
      this.action,
      this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => navigateTo),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              type == 1
                                  ? Icons.directions_car_rounded
                                  : Icons.directions_walk,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Text(time,
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600,
                                    color: textColor))
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TripLocationsWidget(
                      fromLabel: fromLabel,
                      fromAddress: fromAddress,
                      toLabel: toLabel,
                      toAddress: toAddress,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(),
                    SizedBox(
                      height: 8,
                    ),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return InfoWidget(info: info[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SmallSpaceWidget();
                      },
                      shrinkWrap: true,
                      itemCount: info.length,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: PopupMenuButton<int>(
                  offset: Offset(-20, -20),
                  icon: Icon(
                    Icons.more_vert,
                    size: 16,
                  ),
                  onSelected: (int result) {
                    if (result == 2) {
                      onDelete!.call();
                    }
                    print(result);
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text(
                        'Help',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    if (onDelete != null)
                      const PopupMenuItem<int>(
                        value: 2,
                        child: Text('Remove',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
