import 'package:commuting_app_mobile/dto/car/car_response.dart';
import 'package:commuting_app_mobile/dto/direction/get_routes_request.dart';
import 'package:commuting_app_mobile/dto/direction/get_routes_result.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class DirectionService {
  var tokenService = locator.get<TokenService>();

  Future<List<GetRoutesResult>> getRoutes(GetRoutesRequest getRoutesRequest) async {
    Dio dio = new Dio();
    Response response = await dio.post(BASE_URL + DIRECTION_URL,
        data: getRoutesRequest, options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data
          .map<GetRoutesResult>((json) => GetRoutesResult.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to save location');
    }
  }
}
