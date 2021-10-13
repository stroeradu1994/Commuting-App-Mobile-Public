import 'package:calendar_time/calendar_time.dart';
import 'package:commuting_app_mobile/dto/trip/active_driver_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/past_driver_trip_response.dart';
import 'package:commuting_app_mobile/provider/active_driver_trip_provider.dart';
import 'package:commuting_app_mobile/provider/active_trips_provider.dart';
import 'package:commuting_app_mobile/provider/past_driver_trip_provider.dart';
import 'package:commuting_app_mobile/provider/trip_requests_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_trips_provider.dart';
import 'package:commuting_app_mobile/screens/common/main_screen.dart';
import 'package:commuting_app_mobile/screens/trips/driver_map.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/past_trip_service.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PastDriverTrip extends StatelessWidget {
  String id;

  PastDriverTrip(this.id);

  var _pastTripService = locator.get<PastTripService>();

  @override
  Widget build(BuildContext context) {
    var pastDriverTripProvider = Provider.of<PastDriverTripProvider>(context);

    return MainScreen(
        header: AppLocalizations.of(context)!.pastTrip,
        hasBack: true,
        onRefresh: () async {
          await pastDriverTripProvider.fetch(id);
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
        child: _buildWrapper(context, pastDriverTripProvider));
  }

  Widget _buildWrapper(context, pastDriverTripProvider) {
    if (pastDriverTripProvider.getState(id) ==
        PastDriverTripProviderState.NOT_FETCHED) {
      pastDriverTripProvider.fetch(id);
      return LoadingWidget();
    }
    if (pastDriverTripProvider.getState(id) ==
        PastDriverTripProviderState.BUSY) {
      return LoadingWidget();
    }
    if (pastDriverTripProvider.getState(id) ==
        PastDriverTripProviderState.IDLE) {
      return _buildContent(context, pastDriverTripProvider.get(id));
    }
    return LoadingWidget();
  }

  Widget _buildContent(BuildContext context, PastDriverTripResponse t) {
    var pastDriverTripProvider =
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
          (stop.pickup! ? AppLocalizations.of(context)!.tripsPickup : AppLocalizations.of(context)!.tripsDrop) + stop.passengerName!,
          TimeUtils.toCalendarTimeFromString(stop.time.toString()) +
              ' (' +
              TimeUtils.toTimeAgoFromString(stop.time.toString()) +
              ')',
          stop.address != null ? stop.address! : '-',
          stop.confirmed! ? true : false,
          null));
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
        true,
        null));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SpaceWidget(),
          IconWithTextWidget(text: AppLocalizations.of(context)!.driving, icon: Icons.directions_car),
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
            subtitle1: _buildSubtitleForInfoWidget(AppLocalizations.of(context)!.passengers),
            title2: Icon(Icons.map, color: primaryColor),
            subtitle2: _buildSubtitleForInfoWidget(AppLocalizations.of(context)!.viewMap),
            title3: Icon(Icons.star_border, color: primaryColor),
            subtitle3: _buildSubtitleForInfoWidget(t.rating!.toStringAsFixed(1)),
            onThirdTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => DriverMap(new DriverMapData(t.tripId, t.fromLocation!.point, t.toLocation!.point!, t.polyline!, t.stops!.map((e) => e.point!).toList(), withPassenger: false))),
              );
            },
            onSecondTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => DriverMap(new DriverMapData(t.tripId, t.fromLocation!.point, t.toLocation!.point!, t.polyline!, t.stops!.map((e) => e.point!).toList(), withPassenger: false))),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.star),
          //   title: Text(t.rating!.toString()),
          // ),
          SpaceWidget(),
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
}
