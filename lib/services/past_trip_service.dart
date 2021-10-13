import 'package:commuting_app_mobile/dto/trip/active_driver_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/active_passenger_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/generic_past_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/past_driver_trip_response.dart';
import 'package:commuting_app_mobile/dto/trip/past_passenger_trip_response.dart';
import 'package:commuting_app_mobile/services/service_wrapper.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class PastTripService {
  var tokenService = locator.get<TokenService>();
  var serviceWrapper = locator.get<ServiceWrapper>();

  Future getPastTrips() async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.get(
        BASE_URL + PAST_TRIP_URL,
        options: tokenService.getAccessHeader()));

    if (response != null)
      return response
          .map<GenericPastTripResponse>(
              (json) => GenericPastTripResponse.fromJson(json))
          .toList();
    return null;
  }

  Future getPastTripForPassenger(String id) async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.get(
        BASE_URL + PAST_TRIP_URL + '/passenger/' + id,
        options: tokenService.getAccessHeader()));

    if (response != null) return PastPassengerTripResponse.fromJson(response);
    return null;
  }

  Future getPastTripForDriver(String id) async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.get(
        BASE_URL + PAST_TRIP_URL + '/driver/' + id,
        options: tokenService.getAccessHeader()));

    if (response != null) return PastDriverTripResponse.fromJson(response);
    return null;
  }
}
