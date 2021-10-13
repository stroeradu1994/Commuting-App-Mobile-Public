import 'package:calendar_time/calendar_time.dart';
import 'package:commuting_app_mobile/provider/trip_request_provider.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/trip_request_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:commuting_app_mobile/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:commuting_app_mobile/widgets/trip_locations_widget.dart';
import 'package:commuting_app_mobile/dto/trip/trip_request_response_with_matches.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:commuting_app_mobile/widgets/info_widget.dart';
import 'package:commuting_app_mobile/screens/trips/choose_trip.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TripRequest extends StatelessWidget {
  String id;

  TripRequest(this.id);

  var tripRequestService = locator.get<TripRequestService>();

  @override
  Widget build(BuildContext context) {
    var tripRequestProvider = Provider.of<TripRequestProvider>(context);

    return MainScreen(
        header: AppLocalizations.of(context)!.tripstripRequests,
        hasBack: true,
        onRefresh: () async {
          await tripRequestProvider.fetch(id);
          return Future.value(true);
        },
        child: _buildWrapper(context, tripRequestProvider));

  }

  Widget _buildWrapper(context, tripRequestProvider) {

    if (tripRequestProvider.getState(id) == TripRequestProviderState.NOT_FETCHED) {
      tripRequestProvider.fetch(id);
      return LoadingWidget();
    }
    if (tripRequestProvider.getState(id) == TripRequestProviderState.BUSY) {
      return LoadingWidget();
    }
    if (tripRequestProvider.getState(id) == TripRequestProviderState.IDLE) {
      return _buildContent(context, tripRequestProvider.get(id));
    }
    return LoadingWidget();
  }

  Widget _buildContent(context, TripRequestResponseWithMatches t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.directions_walk,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Text('Passenger',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Text(AppLocalizations.of(context)!.arrive + TimeUtils.toCalendarTimeFromString(t.dateTime!.toString()),
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
            height: 32,
          ),
          TripLocationsWidget(
            fromLabel: t.fromLocation!.label!,
            fromAddress: t.fromLocation!.address!,
            toLabel: t.toLocation!.label == null ? '' : t.toLocation!.label!,
            toAddress: t.toLocation!.address!,
          ),
          SizedBox(
            height: 32,
          ),
          InfoWidget(info: t.matches!.length.toString() + AppLocalizations.of(context)!.matchesFound),
          SizedBox(
            height: 16,
          ),
          ..._buildMatches(context, t),
          SizedBox(
            height: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => ChooseTrip(t, 0)),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
              ),
              child: Text(
                AppLocalizations.of(context)!.chooseTrip,
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }

  List<Widget> _buildMatches(context, TripRequestResponseWithMatches t) {
    return t.matches!
        .map((e) => Column(
              children: [
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => ChooseTrip(t, t.matches!.indexOf(e))),
                        );
                      },
                      borderRadius: BorderRadius.circular(5),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.directions_car_rounded,
                                  color: primaryColor,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text(e.driverName!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        color: textColor))
                              ],
                            ),
                            SizedBox(height: 8,),
                            Text(
                                e.carBrand!  + ' ' +  e.carModel!,
                                style: TextStyle(fontSize: 12, color: textColor)),
                            SizedBox(height: 8,),
                            Divider(),
                            SizedBox(height: 8,),
                            Text(
    AppLocalizations.of(context)!.walking + ' ' +
                                    metersToKm(e.pickupWalkingDistance! + e.dropWalkingDistance!) +
                                    ' km',
                                style: TextStyle(fontSize: 12, color: textColor)),
                            Text(
    AppLocalizations.of(context)!.leaveAt +
                                  TimeUtils.toCalendarTimeFromString(e.leaveTime!.toString()),
                              style: TextStyle(fontSize: 12, color: textColor),
                            ),
                            Text(
                            AppLocalizations.of(context)!.arriveAt +
                                TimeUtils.toCalendarTimeFromString(e.arriveTime!.toString()),
                              style: TextStyle(fontSize: 12, color: textColor),
                            )
                          ],
                        ),
                      ),
                    )),
                SizedBox(
                  height: 8,
                ),
              ],
            ))
        .toList();
  }

  String metersToKm(double distance) {
    return (distance / 1000).toStringAsFixed(1);
  }
}
