import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';

class TripLocationsWidget extends StatelessWidget {

  String fromLabel;
  String fromAddress;
  String toLabel;
  String toAddress;


  TripLocationsWidget({
      required this.fromLabel, required this.fromAddress, required this.toLabel, required this.toAddress});

  @override
  Widget build(BuildContext context) {
    return                     Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        children: [
          Column(
            children: [
              Icon(
                Icons.adjust,
                color: primaryColor,
                size: 20,
              ),
              Container(
                width: 2,
                height: 32,
                color: primaryColor,
              ),
              Icon(Icons.adjust, color: primaryColor, size: 20),
            ],
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(fromLabel,
                    style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: textColor)),
                SizedBox(
                  height: 2,
                ),
                Text(fromAddress,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w300,
                        color: textColor)),
                SizedBox(
                  height: 16,
                ),
                Text(toLabel,
                    style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: textColor)),
                SizedBox(
                  height: 2,
                ),
                Text(toAddress,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w300,
                        color: textColor)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
