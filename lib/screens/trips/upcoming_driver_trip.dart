import 'package:background_location/background_location.dart';
import 'package:calendar_time/calendar_time.dart';
import 'package:commuting_app_mobile/dto/trip/confirm_trip.dart';
import 'package:commuting_app_mobile/dto/trip/start_trip.dart';
import 'package:commuting_app_mobile/dto/trip/upcoming_driver_trip_response.dart';
import 'package:commuting_app_mobile/provider/past_trips_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_driver_trip_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_trips_provider.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/screens/trips/active_driver_trip.dart';
import 'package:commuting_app_mobile/screens/trips/driver_map.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/position_service.dart';
import 'package:commuting_app_mobile/services/upcoming_trip_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:commuting_app_mobile/utils/date_time/flutter_datetime_picker.dart';
import 'package:commuting_app_mobile/utils/date_time/i18n_model.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:commuting_app_mobile/widgets/icon_with_text_widget.dart';
import 'package:commuting_app_mobile/widgets/info_widget.dart';
import 'package:commuting_app_mobile/widgets/linear_stepper_widget.dart';
import 'package:commuting_app_mobile/widgets/loading_widget.dart';
import 'package:commuting_app_mobile/widgets/screen_action.dart';
import 'package:commuting_app_mobile/widgets/small_space_widget.dart';
import 'package:commuting_app_mobile/widgets/space_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpcomingDriverTrip extends StatefulWidget {
  String id;

  UpcomingDriverTrip(this.id);

  @override
  _UpcomingDriverTripState createState() => _UpcomingDriverTripState();
}

class _UpcomingDriverTripState extends State<UpcomingDriverTrip> {
  var _upcomingTripService = locator.get<UpcomingTripService>();
  var _positionService = locator.get<PositionService>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var upcomingDriverTripProvider =
        Provider.of<UpcomingDriverTripProvider>(context);
    var pastTripsProvider =
        Provider.of<PastTripsProvider>(context, listen: false);
    var upcomingTripsProvider =
        Provider.of<UpcomingTripsProvider>(context, listen: false);

    return MainScreen(
        loading: loading,
        header: AppLocalizations.of(context)!.upcomingTrip,
        hasBack: true,
        action: ScreenAction(items: [
          new ScreenActionItem(AppLocalizations.of(context)!.cancelTrip,
              () async {
            setState(() {
              loading = true;
            });
            await _upcomingTripService.cancelTrip(widget.id);
            await pastTripsProvider.getPastTrips();
            await upcomingTripsProvider.getUpcomingTrips();
            setState(() {
              loading = false;
            });
            Navigator.of(context).popUntil((route) => route.isFirst);
          })
        ]),
        onRefresh: () async {
          await upcomingDriverTripProvider.fetch(widget.id);
          return Future.value(true);
        },
        child: _buildWrapper(context, upcomingDriverTripProvider));
  }

  Widget _buildWrapper(context, upcomingDriverTripProvider) {
    if (upcomingDriverTripProvider.getState(widget.id) ==
        UpcomingDriverTripProviderState.NOT_FETCHED) {
      upcomingDriverTripProvider.fetch(widget.id);
      return LoadingWidget();
    }
    if (upcomingDriverTripProvider.getState(widget.id) ==
        UpcomingDriverTripProviderState.BUSY) {
      return LoadingWidget();
    }
    if (upcomingDriverTripProvider.getState(widget.id) ==
        UpcomingDriverTripProviderState.IDLE) {
      return _buildContent(context, upcomingDriverTripProvider.get(widget.id));
    }
    return LoadingWidget();
  }

  Widget _buildContent(BuildContext context, UpcomingDriverTripResponse t) {
    var upcomingDriverTripProvider =
        Provider.of<UpcomingDriverTripProvider>(context, listen: false);

    List<LinearStepperStep> steps = [];
    steps.add(LinearStepperStep(
        AppLocalizations.of(context)!.leaveFrom + t.fromLocation!.label!,
        TimeUtils.toCalendarTimeFromString(t.leaveTime!.toString()) +
            ' (' +
            TimeUtils.toTimeAgoFromString(t.leaveTime.toString()) +
            ')',
        t.fromLocation!.address!,
        false,
        null));

    List<Stop> stops = t.passengers!
        .map((e) => [
              Stop(e.firstName, e.lastName, DateTime.parse(e.pickupTime!),
                  e.pickupPoint!, true),
              Stop(e.firstName, e.lastName, DateTime.parse(e.dropTime!),
                  e.dropPoint!, false)
            ])
        .expand((element) => element)
        .toList();
    stops.sort((a, b) => a.time.compareTo(b.time));
    steps.addAll(stops
        .map((e) => LinearStepperStep(
            (e.isPickup
                    ? AppLocalizations.of(context)!.tripsPickup
                    : AppLocalizations.of(context)!.tripsDrop) +
                e.firstName,
            TimeUtils.toCalendarTimeFromString(e.time.toString()) +
                ' (' +
                TimeUtils.toTimeAgoFromString(e.time.toString()) +
                ')',
            '-',
            false,
            null))
        .toList());

    steps.add(LinearStepperStep(
        AppLocalizations.of(context)!.arriveAt + t.toLocation!.label!,
        TimeUtils.toCalendarTimeFromString(t.arriveTime!.toString()) +
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
            text: AppLocalizations.of(context)!.leave +
                TimeUtils.toTimeAgoFromString(t.leaveTime.toString()),
            icon: Icons.timer,
            subtext:
                TimeUtils.toCalendarTimeFromString(t.leaveTime!.toString()),
          ),
          SmallSpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          IconWithTextWidget(
              text: t.carBrand! +
                  ' ' +
                  t.carModel! +
                  ' | ' +
                  t.carColor! +
                  ' | ' +
                  t.carPlate!,
              icon: Icons.directions_car),
          SmallSpaceWidget(),
          IconWithTextWidget(
              text: t.passengers!.length.toString() +
                  AppLocalizations.of(context)!.passengerLowCase,
              icon: Icons.directions_walk),
          SmallSpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          LinearStepperWidget(
            steps: steps,
          ),
          SmallSpaceWidget(),
          Divider(),
          SmallSpaceWidget(),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => DriverMap(new DriverMapData(
                        t.tripId,
                        t.fromLocation!.point,
                        t.toLocation!.point!,
                        t.polyline!,
                        stops.map((e) => e.point).toList(),
                        withPassenger: true))),
              );
            },
            child: IconWithTextWidget(
                text: AppLocalizations.of(context)!.viewMap,
                icon: Icons.map_sharp),
          ),
          SpaceWidget(),
          if (showConfirmButton(t))
            ElevatedButton(
                onPressed: () async {
                  DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    locale: LocaleType.ro,
                    currentTime: TimeUtils.getDateTime(t.leaveTime!),
                    maxTime: TimeUtils.getDateTime(t.leaveTime!)
                        .add(Duration(minutes: 30)),
                    minTime: DateTime.now().add(Duration(minutes: 15)),
                    onChanged: (date) {},
                    onConfirm: (date) async {
                      setState(() {
                        loading = true;
                      });

                      await _upcomingTripService.confirmTrip(new ConfirmTrip(
                          tripId: widget.id, leaveAt: date.toIso8601String()));
                      await upcomingDriverTripProvider.fetch(widget.id);

                      setState(() {
                        loading = false;
                      });
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                ),
                child: Text(
                  AppLocalizations.of(context)!.confirmTrip,
                  style: TextStyle(color: Colors.white),
                )),
          if (showStart(t))
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });

                  await _upcomingTripService
                      .startTrip(new StartTrip(tripId: widget.id));
                  await upcomingDriverTripProvider.fetch(widget.id);
                  await _positionService.startLocation();

                  setState(() {
                    loading = false;
                  });

                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ActiveDriverTrip(widget.id)),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                ),
                child: Text(
                  AppLocalizations.of(context)!.startTrip,
                  style: TextStyle(color: Colors.white),
                )),
          SmallSpaceWidget(),
          _buildInfoWidget(t),
          SpaceWidget(),
        ],
      ),
    );
  }

  bool showConfirmButton(UpcomingDriverTripResponse t) {
    return !t.confirmed!;
  }

  bool showStart(UpcomingDriverTripResponse t) {
    return t.confirmed!;
  }

  Widget _buildInfoWidget(UpcomingDriverTripResponse t) {
    if (t.confirmed!) {
      return InfoWidget(
          info: AppLocalizations.of(context)!.announcePassengersInfo);
    } else {
      return InfoWidget(info: AppLocalizations.of(context)!.confirmTripInfo);
    }
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
