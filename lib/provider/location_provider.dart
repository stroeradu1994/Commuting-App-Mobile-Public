import 'package:commuting_app_mobile/dto/location/location_dto.dart';
import 'package:commuting_app_mobile/dto/location/location_response.dart';
import 'package:commuting_app_mobile/services/location_service.dart';
import 'package:commuting_app_mobile/services/locator.dart';
import 'package:flutter/material.dart';

enum LocationProviderState { NOT_FETCHED, IDLE, BUSY }

class LocationProvider with ChangeNotifier {
  LocationProviderState state = LocationProviderState.NOT_FETCHED;

  List<LocationResponse> locations = [];

  var locationService = locator.get<LocationService>();

  getLocations() async {
    state = LocationProviderState.BUSY;
    locations = await locationService.getLocations();
    state = LocationProviderState.IDLE;
    notifyListeners();
  }
}
