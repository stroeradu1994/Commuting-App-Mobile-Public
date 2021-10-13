import 'package:background_location/background_location.dart';
import 'package:calendar_time/calendar_time.dart';
import 'package:commuting_app_mobile/dto/trip/active_driver_trip_response.dart';
import 'package:commuting_app_mobile/provider/active_driver_trip_provider.dart';
import 'package:commuting_app_mobile/provider/active_trips_provider.dart';
import 'package:commuting_app_mobile/provider/trip_requests_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_trips_provider.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/screens/trips/driver_map.dart';
import 'package:commuting_app_mobile/services/active_trip_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:commuting_app_mobile/widgets/icon_with_text_widget.dart';
import 'package:commuting_app_mobile/widgets/linear_stepper_widget.dart';
import 'package:commuting_app_mobile/widgets/loading_widget.dart';
import 'package:commuting_app_mobile/widgets/small_space_widget.dart';
import 'package:commuting_app_mobile/widgets/space_widget.dart';
import 'package:commuting_app_mobile/widgets/triple_info_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:commuting_app_mobile/dto/trip/trip_action_request.dart';
import 'package:commuting_app_mobile/dto/trip/complete_trip_request.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActiveDriverTrip extends StatelessWidget {
  String id;

  ActiveDriverTrip(this.id);

  var _activeTripService = locator.get<ActiveTripService>();

  @override
  Widget build(BuildContext context) {
    var activeDriverTripProvider =
        Provider.of<ActiveDriverTripProvider>(context);

    return MainScreen(
        header: AppLocalizations.of(context)!.currentTrip,
        hasBack: true,
        onRefresh: () async {
          await activeDriverTripProvider.fetch(id);
          return Future.value(true);
        },
        action: PopupMenuButton<int>(
          offset: Offset(-20, -20),
          icon: Icon(
            Icons.more_vert,
            color: primaryColor,
          ),
          onSelected: (int result) {
            if (result == 2) {}
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
        child: _buildWrapper(context, activeDriverTripProvider));
  }

  Widget _buildWrapper(context, activeDriverTripProvider) {
    if (activeDriverTripProvider.getState(id) ==
        ActiveDriverTripProviderState.NOT_FETCHED) {
      activeDriverTripProvider.fetch(id);
      return LoadingWidget();
    }
    if (activeDriverTripProvider.getState(id) ==
        ActiveDriverTripProviderState.BUSY) {
      return LoadingWidget();
    }
    if (activeDriverTripProvider.getState(id) ==
        ActiveDriverTripProviderState.IDLE) {
      return _buildContent(context, activeDriverTripProvider.get(id));
    }
    return LoadingWidget();
  }

  Widget _buildContent(BuildContext context, ActiveDriverTripResponse t) {
    var activeDriverTripProvider =
        Provider.of<ActiveDriverTripProvider>(context, listen: false);
    var tripRequestProvider =
        Provider.of<TripRequestsProvider>(context, listen: false);
    var upcomingTripProvider =
        Provider.of<UpcomingTripsProvider>(context, listen: false);
    var activeTripProvider =
        Provider.of<ActiveTripsProvider>(context, listen: false);

    List<LinearStepperStep> steps = [];
    steps.add(LinearStepperStep(
        AppLocalizations.of(context)!.leaveFrom + t.fromLocation!.label!,
        TimeUtils.toCalendarTimeFromString(t.leaveTime.toString()) +
            ' (' +
            TimeUtils.toTimeAgoFromString(t.leaveTime.toString()) +
            ')',
        t.fromLocation!.address!,
        true,
        null));

    bool actionApplied = false;
    t.stops!.forEach((stop) {
      steps.add(LinearStepperStep(
          (stop.pickup!
                  ? AppLocalizations.of(context)!.tripsPickup
                  : AppLocalizations.of(context)!.tripsDrop) +
              stop.passengerName!,
          TimeUtils.toCalendarTimeFromString(stop.time.toString()) +
              ' (' +
              TimeUtils.toTimeAgoFromString(stop.time.toString()) +
              ')',
          stop.address != null ? stop.address! : '-',
          stop.confirmed! ? true : false,
          stop.confirmed! || actionApplied
              ? null
              : _buildAction(stop, activeDriverTripProvider, context)));
      if (!(stop.confirmed! || actionApplied)) {
        actionApplied = true;
      }
    });

    steps.add(LinearStepperStep(
        AppLocalizations.of(context)!.arriveAt + t.toLocation!.label!,
        TimeUtils.toCalendarTimeFromString(t.arriveTime.toString()) +
            ' (' +
            TimeUtils.toTimeAgoFromString(t.arriveTime.toString()) +
            ')',
        t.toLocation!.address!,
        false,
        null));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SpaceWidget(),
          IconWithTextWidget(
              text: AppLocalizations.of(context)!.driving,
              icon: Icons.directions_car),
          SmallSpaceWidget(),
          IconWithTextWidget(
            text: AppLocalizations.of(context)!.arrive +
                TimeUtils.toCalendarTimeFromString(t.arriveTime.toString()),
            icon: Icons.timer,
            subtext: TimeUtils.toTimeAgoFromString(t.arriveTime.toString()),
          ),
          SmallSpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          LinearStepperWidget(
            steps: steps,
          ),
          SmallSpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          TripleInfoWidget(
            title1: _buildTitleForInfoWidget(
              t.passengers!.length.toString(),
            ),
            subtitle1: _buildSubtitleForInfoWidget(
                AppLocalizations.of(context)!.passengers),
            title2: Icon(Icons.map, color: primaryColor),
            subtitle2: _buildSubtitleForInfoWidget(
                AppLocalizations.of(context)!.viewMap),
            title3: Icon(Icons.exit_to_app_outlined, color: primaryColor),
            subtitle3:
                _buildSubtitleForInfoWidget(AppLocalizations.of(context)!.open),
            onThirdTap: () async {
              try {
                final availableMaps = await MapLauncher.installedMaps;

                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Wrap(
                            children: <Widget>[
                              for (var map in availableMaps)
                                ListTile(
                                  onTap: () => map.showDirections(
                                      destination: Coords(
                                          t.toLocation!.point!.lat!,
                                          t.toLocation!.point!.lng!),
                                      destinationTitle: t.toLocation!.label,
                                      origin: Coords(
                                          t.fromLocation!.point!.lat!,
                                          t.fromLocation!.point!.lng!),
                                      originTitle: t.fromLocation!.label,
                                      waypoints: t.stops!
                                          .map(
                                              (e) => fromLatLngString(e.point!))
                                          .toList()),
                                  title: Text(map.mapName),
                                  leading: Icon(Icons.map),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } catch (e) {
                print(e);
              }
            },
            onSecondTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => DriverMap(new DriverMapData(
                        t.tripId,
                        t.fromLocation!.point,
                        t.toLocation!.point!,
                        t.polyline!,
                        t.stops!.map((e) => e.point!).toList(),
                        withPassenger: true))),
              );
            },
          ),
          SpaceWidget(),
          if (showCompleteButton(t))
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await _activeTripService
                          .complete(new CompleteTripRequest(tripId: id));
                      await tripRequestProvider.getTripRequests();
                      await upcomingTripProvider.getUpcomingTrips();
                      await activeTripProvider.getActiveTrips();
                      await BackgroundLocation.stopLocationService();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.completeTrip,
                      style: TextStyle(color: Colors.white),
                    )),
                SpaceWidget(),
              ],
            )
        ],
      ),
    );
  }

  showCompleteButton(ActiveDriverTripResponse t) {
    return t.stops!.where((stop) => !stop.confirmed!).length == 0;
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

  _buildAction(
      Stops stop, ActiveDriverTripProvider activeDriverTripProvider, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SmallSpaceWidget(),
        ElevatedButton(
            onPressed: () async {
              if (stop.pickup!) {
                // _activeTripService.pickup
                if (stop.arrived!) {
                  await _activeTripService.pickup(
                      new TripActionRequest(tripId: id, stopId: stop.id));
                } else {
                  await _activeTripService.arrivedAtPickup(
                      new TripActionRequest(tripId: id, stopId: stop.id));
                }
              } else {
                await _activeTripService
                    .drop(new TripActionRequest(tripId: id, stopId: stop.id));
              }
              activeDriverTripProvider.fetch(id);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryColor),
            ),
            child: Text(
              stop.pickup!
                  ? (stop.arrived!
                      ? AppLocalizations.of(context)!.confirmPickup
                      : AppLocalizations.of(context)!.arrivedAtPickup)
                  : AppLocalizations.of(context)!.confirmDrop,
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }

  Coords fromLatLngString(String latlngString) {
    return new Coords(double.parse(latlngString.split(',')[0].trim()),
        double.parse(latlngString.split(',')[1].trim()));
  }
}
