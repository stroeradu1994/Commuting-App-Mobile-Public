import 'package:commuting_app_mobile/dto/trip/generic_active_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/generic_upcoming_trip_response.dart';
import 'package:commuting_app_mobile/provider/active_trips_provider.dart';
import 'package:commuting_app_mobile/provider/trip_requests_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_trips_provider.dart';
import 'package:commuting_app_mobile/screens/common/main_screen_with_drawer.dart';
import 'package:commuting_app_mobile/screens/trips/active_driver_trip.dart';
import 'package:commuting_app_mobile/screens/trips/active_passenger_trip.dart';
import 'package:commuting_app_mobile/screens/trips/trip_request.dart';
import 'package:commuting_app_mobile/screens/trips/upcoming_driver_trip.dart';
import 'package:commuting_app_mobile/screens/trips/upcoming_passenger_trip.dart';
import 'package:commuting_app_mobile/screens/widgets_with_header.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/trip_request_service.dart';
import 'package:commuting_app_mobile/services/upcoming_trip_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:commuting_app_mobile/widgets/trip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'new_trip/new_trip.dart';

class Trips extends StatelessWidget {
  var tripRequestService = locator.get<TripRequestService>();
  var _upcomingTripService = locator.get<UpcomingTripService>();

  @override
  Widget build(BuildContext context) {
    var tripRequestProvider = Provider.of<TripRequestsProvider>(context);
    var upcomingTripProvider = Provider.of<UpcomingTripsProvider>(context);
    var activeTripProvider = Provider.of<ActiveTripsProvider>(context);

    initProviders(
        tripRequestProvider, upcomingTripProvider, activeTripProvider);

    if (tripRequestProvider.state == TripRequestsProviderState.IDLE &&
        upcomingTripProvider.state == UpcomingTripsProviderState.IDLE &&
        activeTripProvider.state == ActiveTripsProviderState.IDLE) {
      List<Widget> tripRequests =
          _buildTripRequestWidgets(tripRequestProvider, context);
      List<Widget> upcomingTrips =
          _buildUpcomingTripWidgets(upcomingTripProvider, context);
      List<Widget> activeTrips =
          _buildActiveTripWidgets(activeTripProvider, context);

      return MainScreenWithDrawer(
        position: 0,
        onRefresh: () async {
          await tripRequestProvider.getTripRequests();
          await upcomingTripProvider.getUpcomingTrips();
          await activeTripProvider.getActiveTrips();
          return Future.value(true);
        },
        child: Column(
          children: [
            activeTrips.isEmpty
                ? SizedBox.shrink()
                : WidgetsWithHeader(
                    header: AppLocalizations.of(context)!.tripsActiveTrip,
                    widgets: activeTrips),
            tripRequests.isEmpty
                ? SizedBox.shrink()
                : WidgetsWithHeader(
                    header: AppLocalizations.of(context)!.tripstripRequests,
                    widgets: tripRequests),
            upcomingTrips.isEmpty
                ? SizedBox.shrink()
                : WidgetsWithHeader(
                    header: AppLocalizations.of(context)!.tripsUpcomingTrips,
                    widgets: upcomingTrips),
            activeTrips.isEmpty && tripRequests.isEmpty && upcomingTrips.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 200,
                          child: SvgPicture.asset(
                              'assets/images/undraw_empty_street_sfxm.svg'),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => NewTrip()),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.tripsCreateTrip,
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      );
    } else {
      return MainScreenWithDrawer(
          position: 0,
          onRefresh: () async {
            await tripRequestProvider.getTripRequests();
            await upcomingTripProvider.getUpcomingTrips();
            await activeTripProvider.getActiveTrips();
            return Future.value(true);
          },
          child: Center(
            child: CircularProgressIndicator(),
          ));
    }
  }

  initProviders(
      TripRequestsProvider tripRequestProvider,
      UpcomingTripsProvider upcomingTripProvider,
      ActiveTripsProvider activeTripProvider) {
    if (tripRequestProvider.state == TripRequestsProviderState.NOT_FETCHED)
      tripRequestProvider.getTripRequests();
    if (upcomingTripProvider.state == UpcomingTripsProviderState.NOT_FETCHED)
      upcomingTripProvider.getUpcomingTrips();
    if (activeTripProvider.state == ActiveTripsProviderState.NOT_FETCHED)
      activeTripProvider.getActiveTrips();
  }

  List<Widget> _buildTripRequestWidgets(
      TripRequestsProvider tripRequestProvider, context) {
    return tripRequestProvider.tripRequests
        .map<Widget>((e) => TripCard(
              type: 2,
              time: TimeUtils.toCalendarTimeFromString(e.dateTime!),
              fromLabel: e.fromLocation!.label!,
              fromAddress: e.fromLocation!.address!,
              toLabel: e.toLocation!.label == null ? '' : e.toLocation!.label!,
              toAddress: e.toLocation!.address!,
              info: [
                e.matches.toString() +
                    AppLocalizations.of(context)!.tripsMatchesFound,
                AppLocalizations.of(context)!.tripsChooseOne
              ],
              navigateTo: TripRequest(e.id!),
              actionText: 'Choose Trip',
              action: () {},
              onDelete: () async {
                await tripRequestService.deleteTripRequest(e.id!);
                tripRequestProvider.getTripRequests();
              },
            ))
        .toList();
  }

  List<Widget> _buildUpcomingTripWidgets(
      UpcomingTripsProvider upcomingTripProvider, context) {
    return upcomingTripProvider.upcomingTrips
        .map<Widget>((e) => TripCard(
              type: e.driver! ? 1 : 2,
              time: TimeUtils.toCalendarTimeFromString(e.leaveTime!),
              fromLabel: e.fromLocation!.label!,
              fromAddress: e.fromLocation!.address!,
              toLabel: e.toLocation!.label!,
              toAddress: e.toLocation!.address!,
              info: getUpcomingInfoMessages(e, context),
              navigateTo: e.driver!
                  ? UpcomingDriverTrip(e.tripId!)
                  : UpcomingPassengerTrip(e.tripId!),
              actionText: 'Confirm Trip',
              action: () {},
              onDelete: () async {
                await _upcomingTripService.cancelTrip(e.tripId!);
                upcomingTripProvider.getUpcomingTrips();
              },
            ))
        .toList();
  }

  getUpcomingInfoMessages(GenericUpcomingTripResponse t, context) {
    if (t.driver!) {
      if (t.confirmed!) {
        return [
          t.passengers.toString() +
              AppLocalizations.of(context)!.tripsPassnegersJoin,
          AppLocalizations.of(context)!.tripsStartTrip,
        ];
      } else {
        return [
          t.passengers.toString() +
              AppLocalizations.of(context)!.tripsPassnegersJoin,
          AppLocalizations.of(context)!.tripsConfirmTrip,
        ];
      }
    } else {
      if (t.confirmed!) {
        return [
          AppLocalizations.of(context)!.tripsTripConfirmed,
          AppLocalizations.of(context)!.leaveAt +
              TimeUtils.toCalendarTimeFromString(t.leaveTime!)
        ];
      } else {
        return [
          AppLocalizations.of(context)!.tripsTripNotConfirmed,
          AppLocalizations.of(context)!.leaveAt +
              TimeUtils.toCalendarTimeFromString(t.leaveTime!)
        ];
      }
    }
  }

  List<Widget> _buildActiveTripWidgets(
      ActiveTripsProvider activeTripsProvider, context) {
    return activeTripsProvider.activeTrips
        .map<Widget>((e) => TripCard(
              type: e.driver! ? 1 : 2,
              time: TimeUtils.toCalendarTimeFromString(e.arriveTime!),
              fromLabel: e.fromLocation!.label!,
              fromAddress: e.fromLocation!.address!,
              toLabel: e.toLocation!.label!,
              toAddress: e.toLocation!.address!,
              info: [AppLocalizations.of(context)!.tripsWaitingForConfirmation],
              navigateTo: e.driver!
                  ? ActiveDriverTrip(e.tripId!)
                  : ActivePassengerTrip(e.tripId!),
              actionText: 'Confirm Trip',
              action: () {},
              onDelete: () async {
                await _upcomingTripService.cancelTrip(e.tripId!);
                activeTripsProvider.getActiveTrips();
              },
            ))
        .toList();
  }

  getActiveInfoMessage(GenericActiveTripResponse t, context) {
    if (t.driver!) {
      return [
        t.nextStopPassengerName == null
            ? AppLocalizations.of(context)!.tripsCompleted
            : (t.pickup!
                    ? AppLocalizations.of(context)!.tripsPickup
                    : AppLocalizations.of(context)!.tripsDrop) +
                t.nextStopPassengerName!,
      ];
    } else {
      if (t.next!) {
        return [
          t.pickup!
              ? AppLocalizations.of(context)!.tripsNextForPickup
              : AppLocalizations.of(context)!.tripsNextForDrop,
          TimeUtils.toTimeAgoFromString(t.pickUpDropTime!)
        ];
      } else {
        return [''];
      }
    }
  }
}
