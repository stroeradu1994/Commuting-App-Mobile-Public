import 'package:commuting_app_mobile/dto/trip/trip_request_response.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/trip_request_service.dart';
import 'package:commuting_app_mobile/services/upcoming_trip_service.dart';
import 'package:flutter/material.dart';
import 'package:commuting_app_mobile/dto/trip/generic_upcoming_trip_response.dart';

enum UpcomingTripsProviderState { NOT_FETCHED, IDLE, BUSY }

class UpcomingTripsProvider with ChangeNotifier {
  UpcomingTripsProviderState state = UpcomingTripsProviderState.NOT_FETCHED;

  List<GenericUpcomingTripResponse> upcomingTrips = [];

  var upcomingTripService = locator.get<UpcomingTripService>();

  Future getUpcomingTrips() async {
    state = UpcomingTripsProviderState.BUSY;
    upcomingTrips = await upcomingTripService.getUpcomingTrips();
    state = UpcomingTripsProviderState.IDLE;
    notifyListeners();
  }
}
