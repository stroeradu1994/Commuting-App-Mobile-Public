import 'package:commuting_app_mobile/provider/trip_requests_provider.dart';
import 'package:commuting_app_mobile/provider/upcoming_trips_provider.dart';
import 'package:commuting_app_mobile/screens/new_trip/new_trip_driver_time.dart';
import 'package:commuting_app_mobile/screens/new_trip/new_trip_passenger_time.dart';
import 'package:commuting_app_mobile/screens/new_trip/new_trip_route.dart';
import 'package:commuting_app_mobile/screens/new_trip/new_trip_type.dart';
import 'package:commuting_app_mobile/screens/trips/trip_request.dart';
import 'package:commuting_app_mobile/screens/trips/upcoming_driver_trip.dart';
import 'package:commuting_app_mobile/services/creation_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/trip_request_service.dart';
import 'package:commuting_app_mobile/services/upcoming_trip_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:commuting_app_mobile/services/trip_availability_service.dart';
import 'package:commuting_app_mobile/dto/trip/trip_availability_request.dart';

import '../common/main_screen.dart';
import 'new_trip_car.dart';
import 'new_trip_location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTrip extends StatefulWidget {
  @override
  _NewTripState createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {
  var creationService = locator.get<CreationService>();

  var _upcomingTripService = locator.get<UpcomingTripService>();
  var tripRequestService = locator.get<TripRequestService>();
  var tripAvailabilityService = locator.get<TripAvailabilityService>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return MainScreen(
        loading: loading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NewTripType(_refresh),
            showCarSelection() ? NewTripCar(_refresh) : SizedBox.shrink(),
            showFromLocation()
                ? NewTripLocation(_refresh, true)
                : SizedBox.shrink(),
            showToLocation()
                ? NewTripLocation(_refresh, false)
                : SizedBox.shrink(),
            showTimeSelection()
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                isDriverTrip()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NewTripDriverTime(_refresh),
                    NewTripRoute(_refresh)
                  ],
                )
                    : NewTripPassengerTime(_refresh),
                SizedBox(
                  height: 32,
                ),
                if (shouldShowAction()) _buildAction()
              ],
            )
                : SizedBox.shrink(),
            SizedBox(
              height: 32,
            ),
          ],
        ),
        hasBack: true,
        header: AppLocalizations.of(context)!.newTripTitle);
  }

  bool showTimeSelection() {
    return creationService.createTripDto != null &&
        creationService.createTripDto!.to != null ||
        creationService.createTripRequestDto != null &&
            creationService.createTripRequestDto!.to != null;
  }

  bool showCarSelection() {
    return creationService.createTripDto != null;
  }

  bool showFromLocation() {
    return creationService.createTripDto != null &&
        creationService.createTripDto!.carId != null ||
        creationService.createTripRequestDto != null;
  }

  bool showToLocation() {
    return creationService.createTripDto != null &&
        creationService.createTripDto!.from != null ||
        creationService.createTripRequestDto != null &&
            creationService.createTripRequestDto!.from != null;
  }

  bool isDriverTrip() {
    return creationService.createTripDto != null;
  }

  void _refresh() {
    setState(() {});
  }

  bool shouldShowAction() {
    return creationService.createTripDto != null ? creationService
        .createTripDto!.routeId != null : creationService
        .createTripRequestDto != null ? creationService.createTripRequestDto!
        .to != null : false;
  }

  _buildAction() {
    var upcomingTripsProvider = Provider.of<UpcomingTripsProvider>(
        context, listen: false);
    var tripRequestsProvider = Provider.of<TripRequestsProvider>(
        context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: ElevatedButton(
          onPressed: () async {
            setState(() {
              loading = true;
            });


            String? id;
            if (creationService.createTripDto != null) {
              bool response = await tripAvailabilityService.checkAvailability(new TripAvailabilityRequest(dateTime: creationService.createTripDto!.leaveAt, driver: true, asap: false));

              if (response) {
                id = await _upcomingTripService.createTrip(
                    creationService.createTripDto!);
              }
            }
            if (creationService.createTripRequestDto != null) {
              bool response = await tripAvailabilityService.checkAvailability(new TripAvailabilityRequest(dateTime: creationService.createTripRequestDto!.arriveBy, driver: false, asap: creationService.createTripRequestDto!.asap));

              if (response) {
                id = await tripRequestService
                    .createTripRequest(creationService.createTripRequestDto!);
              }
            }

            if (id != null) {
              await upcomingTripsProvider.getUpcomingTrips();
              await tripRequestsProvider.getTripRequests();

              bool isTrip = creationService.createTripDto != null;
              creationService.createTripDto = null;
              creationService.createTripRequestDto = null;

              setState(() {
                loading = false;
              });

              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) =>
                isTrip
                    ? UpcomingDriverTrip(id!)
                    : TripRequest(id!)),
              );
            } else {
              setState(() {
                loading = false;
              });
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
          ),
          child: Text(
            AppLocalizations.of(context)!.tripsCreateTrip,
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
