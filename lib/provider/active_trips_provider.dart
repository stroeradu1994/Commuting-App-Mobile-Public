import 'package:commuting_app_mobile/dto/trip/generic_active_trip_response.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:commuting_app_mobile/services/active_trip_service.dart';
import 'package:flutter/material.dart';

enum ActiveTripsProviderState { NOT_FETCHED, IDLE, BUSY }

class ActiveTripsProvider with ChangeNotifier {
  ActiveTripsProviderState state = ActiveTripsProviderState.NOT_FETCHED;

  List<GenericActiveTripResponse> activeTrips = [];

  var _activeTripService = locator.get<ActiveTripService>();

  Future getActiveTrips() async {
    state = ActiveTripsProviderState.BUSY;
    activeTrips = await _activeTripService.getActiveTrips();
    state = ActiveTripsProviderState.IDLE;
    notifyListeners();
  }
}
