import 'package:commuting_app_mobile/dto/trip/upcoming_passenger_trip_response.dart';
import 'package:commuting_app_mobile/provider/active_trips_provider.dart';
import 'package:commuting_app_mobile/provider/trip_requests_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_passenger_trip_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_trips_provider.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/screens/trips/passenger_map.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/match_service.dart';
import 'package:commuting_app_mobile/services/notification_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:commuting_app_mobile/widgets/double_expanded_info_widget.dart';
import 'package:commuting_app_mobile/widgets/icon_with_text_widget.dart';
import 'package:commuting_app_mobile/widgets/info_widget.dart';
import 'package:commuting_app_mobile/widgets/linear_stepper_widget.dart';
import 'package:commuting_app_mobile/widgets/loading_widget.dart';
import 'package:commuting_app_mobile/widgets/screen_action.dart';
import 'package:commuting_app_mobile/widgets/small_space_widget.dart';
import 'package:commuting_app_mobile/widgets/space_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class UpcomingPassengerTrip extends StatelessWidget {
  String id;

  UpcomingPassengerTrip(this.id);

  var matchService = locator.get<MatchService>();
  var notificationService = locator.get<NotificationService>();

  @override
  Widget build(BuildContext context) {
    var upcomingPassengerTripProvider =
        Provider.of<UpcomingPassengerTripProvider>(context);

    var tripRequestProvider =
        Provider.of<TripRequestsProvider>(context, listen: false);
    var upcomingTripProvider =
        Provider.of<UpcomingTripsProvider>(context, listen: false);
    var activeTripProvider =
        Provider.of<ActiveTripsProvider>(context, listen: false);

    return MainScreen(
        header: AppLocalizations.of(context)!.upcomingTrip,
        hasBack: true,
        action: ScreenAction(items: [
          new ScreenActionItem(AppLocalizations.of(context)!.chooseOtherTrip,
              () async {
            var result = await matchService.unmatch(id);
            if (result != null) {
              await tripRequestProvider.getTripRequests();
              await upcomingTripProvider.getUpcomingTrips();
              await activeTripProvider.getActiveTrips();
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          })
        ]),
        onRefresh: () async {
          await upcomingPassengerTripProvider.fetch(id);
          return Future.value(true);
        },
        child: _buildWrapper(context, upcomingPassengerTripProvider));
  }

  Widget _buildWrapper(context, upcomingPassengerTripProvider) {
    if (upcomingPassengerTripProvider.getState(id) ==
        UpcomingPassengerTripProviderState.NOT_FETCHED) {
      upcomingPassengerTripProvider.fetch(id);
      return LoadingWidget();
    }
    if (upcomingPassengerTripProvider.getState(id) ==
        UpcomingPassengerTripProviderState.BUSY) {
      return LoadingWidget();
    }
    if (upcomingPassengerTripProvider.getState(id) ==
        UpcomingPassengerTripProviderState.IDLE) {
      return _buildContent(context, upcomingPassengerTripProvider.get(id));
    }
    return LoadingWidget();
  }

  Widget _buildContent(BuildContext context, UpcomingPassengerTripResponse t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SpaceWidget(),
          IconWithTextWidget(
              text: AppLocalizations.of(context)!.passenger,
              icon: Icons.directions_walk),
          SmallSpaceWidget(),
          IconWithTextWidget(
            text: TimeUtils.toCalendarTimeFromString(t.leaveTime!),
            icon: Icons.timer,
            subtext: TimeUtils.toTimeAgoFromString(t.leaveTime!),
          ),
          SmallSpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          LinearStepperWidget(
            steps: [
              LinearStepperStep(
                  AppLocalizations.of(context)!.leaveFrom +
                      t.fromLocation!.label!,
                  TimeUtils.toCalendarTimeFromString(t.leaveTime!),
                  t.fromLocation!.address!,
                  false,
                  null),
              LinearStepperStep(
                  AppLocalizations.of(context)!.getPickedUp + t.driverName!,
                  TimeUtils.toCalendarTimeFromString(t.pickupTime!),
                  '-',
                  false,
                  null),
              LinearStepperStep(
                  AppLocalizations.of(context)!.getDropped + t.driverName!,
                  TimeUtils.toCalendarTimeFromString(t.dropTime!),
                  '-',
                  false,
                  null),
              LinearStepperStep(
                  AppLocalizations.of(context)!.arriveAt + t.toLocation!.label!,
                  TimeUtils.toCalendarTimeFromString(t.arriveTime!),
                  t.toLocation!.address!,
                  false,
                  null),
            ],
          ),
          SmallSpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          DoubleExpandedInfoWidget(
            title1: Text(t.driverName!,
                style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400,
                    color: textColor)),
            title2: Text(t.driverRating!.toStringAsFixed(1),
                style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400,
                    color: textColor)),
            subtitle1: Text(
                t.carBrand! + ' ' + t.carModel! + ', ' + t.carColor!,
                style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400,
                    color: textColor)),
            subtitle2: Text(AppLocalizations.of(context)!.rating,
                style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400,
                    color: textColor)),
          ),
          SpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          t.confirmed!
              ? InfoWidget(
                  info: AppLocalizations.of(context)!.tripsTripConfirmed)
              : InfoWidget(
                  info: AppLocalizations.of(context)!.tripNotYetConfirmed),
          SmallSpaceWidget(),
          InfoWidget(info: AppLocalizations.of(context)!.meetWithDriver),
          SmallSpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => PassengerMap(new PassengerMapData(
                        t.tripId,
                        t.driverId,
                        t.fromLocation!.point,
                        t.toLocation!.point!,
                        t.pickupPoint!,
                        t.dropPoint!,
                        t.polyline!))),
              );
            },
            child: IconWithTextWidget(
                text: AppLocalizations.of(context)!.viewMap,
                icon: Icons.map_sharp),
          ),
          SpaceWidget(),
        ],
      ),
    );
  }
}
