import 'package:commuting_app_mobile/dto/trip/trip_request_response_with_matches.dart';
import 'package:commuting_app_mobile/dto/trip/create_trip_request_dto.dart';
import 'package:commuting_app_mobile/dto/trip/trip_request_response.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class TripRequestService {
  var tokenService = locator.get<TokenService>();

  Future createTripRequest(CreateTripRequestDto createTripRequestDto) async {
    Dio dio = new Dio();
    Response response = await dio.post(BASE_URL + TRIP_REQUEST_URL,
        data: createTripRequestDto,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to save location');
    }
  }

  Future getTripRequests() async {
    Dio dio = new Dio();
    Response response = await dio.get(BASE_URL + TRIP_REQUEST_URL,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data
          .map<TripRequestResponse>((json) => TripRequestResponse.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to save location');
    }
  }

  Future getTripRequest(String id) async {
    Dio dio = new Dio();
    Response response = await dio.get(BASE_URL + TRIP_REQUEST_URL + '/' + id,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return TripRequestResponseWithMatches.fromJson(response.data);
    } else {
      throw Exception('Failed to save location');
    }
  }

  Future deleteTripRequest(String id) async {
    Dio dio = new Dio();
    Response response = await dio.delete(BASE_URL + TRIP_REQUEST_URL + '/' + id,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to save location');
    }
  }
}
