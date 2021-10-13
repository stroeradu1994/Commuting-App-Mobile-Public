import 'package:commuting_app_mobile/dto/location/create_location_request.dart';
import 'package:commuting_app_mobile/dto/location/location_response.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';


class LocationService {

  var tokenService = locator.get<TokenService>();

  Future saveLocation(CreateLocationRequest createLocationRequest) async {
    Dio dio = new Dio();
    Response response = await dio.post(
        BASE_URL + LOCATION_URL,
        data: createLocationRequest,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to save location');
    }
  }

  Future<List<LocationResponse>> getLocations() async {
    Dio dio = new Dio();
    Response response = await dio.get(
        BASE_URL + LOCATION_URL,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data
          .map<LocationResponse>((json) => LocationResponse.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to get locations');
    }
  }
}
