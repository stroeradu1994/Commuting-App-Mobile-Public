import 'package:calendar_time/calendar_time.dart';
import 'package:commuting_app_mobile/dto/trip/active_passenger_trip_response.dart';
import 'package:commuting_app_mobile/provider/active_passenger_trip_provider.dart';
import 'package:commuting_app_mobile/screens/common/common_header.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/screens/trips/passenger_map.dart';
import 'package:commuting_app_mobile/services/active_trip_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:commuting_app_mobile/widgets/double_expanded_info_widget.dart';
import 'package:commuting_app_mobile/widgets/icon_with_text_widget.dart';
import 'package:commuting_app_mobile/widgets/linear_stepper_widget.dart';
import 'package:commuting_app_mobile/widgets/loading_widget.dart';
import 'package:commuting_app_mobile/widgets/small_space_widget.dart';
import 'package:commuting_app_mobile/widgets/space_widget.dart';
import 'package:commuting_app_mobile/widgets/triple_info_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivePassengerTrip extends StatelessWidget {
  String id;

  ActivePassengerTrip(this.id);

  var _activeTripService = locator.get<ActiveTripService>();

  @override
  Widget build(BuildContext context) {
    var activePassengerTripProvider =
        Provider.of<ActivePassengerTripProvider>(context);

    return MainScreen(
        header: AppLocalizations.of(context)!.currentTrip,
        hasBack: true,
        onRefresh: () async {
          await activePassengerTripProvider.fetch(id);
          return Future.value(true);
        },
        action: PopupMenuButton<int>(
          // offset: Offset(-20, -20),
          icon: Icon(
            Icons.more_vert,
            color: primaryColor,
          ),
          onSelected: (int result) {
            if (result == 2) {}
            print(result);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            const PopupMenuItem<int>(
              value: 1,
              child: Text(
                'Help',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const PopupMenuItem<int>(
              value: 2,
              child: Text('Remove',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        child: _buildWrapper(context, activePassengerTripProvider));
  }

  Widget _buildWrapper(context, activePassengerTripProvider) {
    if (activePassengerTripProvider.getState(id) ==
        ActivePassengerTripProviderState.NOT_FETCHED) {
      activePassengerTripProvider.fetch(id);
      return LoadingWidget();
    }
    if (activePassengerTripProvider.getState(id) ==
        ActivePassengerTripProviderState.BUSY) {
      return LoadingWidget();
    }
    if (activePassengerTripProvider.getState(id) ==
        ActivePassengerTripProviderState.IDLE) {
      return _buildContent(context, activePassengerTripProvider.get(id));
    }
    return LoadingWidget();
  }

  Widget _buildContent(BuildContext context, ActivePassengerTripResponse t) {
    var activePassengerTripProvider =
        Provider.of<ActivePassengerTripProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SpaceWidget(),
          IconWithTextWidget(
              text: AppLocalizations.of(context)!.passenger, icon: Icons.directions_walk_outlined),
          SmallSpaceWidget(),
          IconWithTextWidget(
            text: TimeUtils.toCalendarTimeFromString(t.leaveTime.toString()),
            icon: Icons.timer,
            subtext: TimeUtils.toTimeAgoFromString(t.leaveTime.toString()),
          ),
          SmallSpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          LinearStepperWidget(
            steps: [
              LinearStepperStep(
                  AppLocalizations.of(context)!.leaveFrom + t.fromLocation!.label!,
                  TimeUtils.toCalendarTimeFromString(t.leaveTime.toString()),
                  t.fromLocation!.address!,
                  true, null),
              LinearStepperStep(
                  AppLocalizations.of(context)!.driverArrivedAtPickup,
                  TimeUtils.toCalendarTimeFromString(t.pickupTime.toString()),
                  t.pickupAddress,
                  t.arrivedAtPickup!, null),
              LinearStepperStep(
                  AppLocalizations.of(context)!.getPickedUp + t.driverName!,
                  TimeUtils.toCalendarTimeFromString(t.pickupTime.toString()),
                  t.pickupAddress,
                  t.pickedUp!, null),
              LinearStepperStep(
                  AppLocalizations.of(context)!.getDropped + t.driverName!,
                  TimeUtils.toCalendarTimeFromString(t.dropTime.toString()),
                  t.dropAddress,
                  t.dropped!, null),
              LinearStepperStep(
                  AppLocalizations.of(context)!.arriveAt + t.toLocation!.label!,
                  TimeUtils.toCalendarTimeFromString(t.arriveTime.toString()),
                  t.toLocation!.address,
                  false, null),
            ],
          ),
          SmallSpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          DoubleExpandedInfoWidget(
            title1: _buildTitleForInfoWidget(t.driverName!),
            title2: _buildTitleForInfoWidget(t.driverRating!.toStringAsFixed(1)),
            subtitle1: _buildSubtitleForInfoWidget(
                t.carBrand! + ' ' + t.carModel! + ', ' + t.carColor!),
            subtitle2: _buildSubtitleForInfoWidget(AppLocalizations.of(context)!.rating),
          ),
          SmallSpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          TripleInfoWidget(
            title1: _buildTitleForInfoWidget(
                metersToKm(t.pickupWalkingDistance! + t.dropWalkingDistance!) +
                    ' km'),
            subtitle1: _buildSubtitleForInfoWidget(AppLocalizations.of(context)!.walking),
            title2:
                _buildTitleForInfoWidget(metersToKm(t.tripDistance!) + ' km'),
            subtitle2: _buildSubtitleForInfoWidget(AppLocalizations.of(context)!.trip),
            title3: Icon(Icons.map, color: primaryColor),
            subtitle3: _buildSubtitleForInfoWidget(AppLocalizations.of(context)!.map),
            onThirdTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => PassengerMap(new PassengerMapData(t.tripId, t.driverId, t.fromLocation!.point, t.toLocation!.point!, t.pickupPoint!, t.dropPoint!, t.polyline!, withDriver: true))),
              );
            },
          ),
          SpaceWidget(),
        ],
      ),
    );
  }

  _buildTitleForInfoWidget(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 14,
            letterSpacing: 1,
            fontWeight: FontWeight.w400,
            color: textColor));
  }

  _buildSubtitleForInfoWidget(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.w400,
            color: textColor));
  }

  String metersToKm(double distance) {
    return (distance / 1000).toStringAsFixed(1);
  }
}

class Stop {
  String firstName;
  String lastName;
  DateTime time;
  String point;
  bool isPickup;

  Stop(this.firstName, this.lastName, this.time, this.point, this.isPickup);
}
