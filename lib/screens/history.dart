import 'package:commuting_app_mobile/screens/trips/past_driver_trip.dart';
import 'package:commuting_app_mobile/screens/trips/past_passenger_trip.dart';
import 'package:commuting_app_mobile/screens/widgets_with_header.dart';
import 'package:commuting_app_mobile/utils/time_utils.dart';
import 'package:commuting_app_mobile/widgets/trip_card.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:commuting_app_mobile/screens/common/main_screen_with_drawer.dart';
import 'package:commuting_app_mobile/provider/past_trips_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:commuting_app_mobile/dto/trip/generic_past_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/trip_status.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class History extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var pastTripsProvider = Provider.of<PastTripsProvider>(context);

    if (pastTripsProvider.state == PastTripsProviderState.NOT_FETCHED)
      pastTripsProvider.getPastTrips();

    if (pastTripsProvider.state == PastTripsProviderState.IDLE) {
      return MainScreenWithDrawer(
          position: 1,
          onRefresh: () async {
            await pastTripsProvider.getPastTrips();
            ;
            return Future.value(true);
          },
          child: Center(
            child: _buildContent(pastTripsProvider, context),
          ));
    } else {
      return MainScreenWithDrawer(
          position: 1,
          onRefresh: () async {
            await pastTripsProvider.getPastTrips();
            ;
            return Future.value(true);
          },
          child: Center(
            child: CircularProgressIndicator(),
          ));
    }
  }

  _buildContent(PastTripsProvider pastTripsProvider, context) {
    List<Widget> widgets = pastTripsProvider.trips.map((e) => TripCard(
      type: e.driver! ? 1 : 2,
      time: TimeUtils.toTimeAgoFromString(e.arriveTime!),
      fromLabel: e.fromLocation!.label!,
      fromAddress: e.fromLocation!.address!,
      toLabel: e.toLocation!.label!,
      toAddress: e.toLocation!.address!,
      info: getInfo(e, context),
      navigateTo: e.driver!
          ? PastDriverTrip(e.tripId!)
          : PastPassengerTrip(e.tripId!),
    )).toList();

    return Column(
      children: [
        WidgetsWithHeader(header: AppLocalizations.of(context)!.pastTrips, widgets: widgets),
      ],
    );
  }

  getInfo(GenericPastTripResponse trip, context) {
    TripStatus status = EnumToString.fromString(TripStatus.values, trip.status!)!;
    if (status == TripStatus.COMPLETED) {
      return [AppLocalizations.of(context)!.tripsCompleted];
    }
    if (status == TripStatus.EXPIRED) {
      return [AppLocalizations.of(context)!.tripExpired];
    }
    if (status == TripStatus.CANCELLED) {
      return [AppLocalizations.of(context)!.tripCancelledByDriver];
    }
    if (status == TripStatus.NO_PASSENGERS) {
      return [AppLocalizations.of(context)!.tripDismissed];
    }

  }
}
