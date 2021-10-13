import 'package:commuting_app_mobile/dto/account/add_name_request.dart';
import 'package:commuting_app_mobile/dto/account/authorization_response.dart';
import 'package:commuting_app_mobile/dto/account/email_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/email_verification_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_verification_request.dart';
import 'package:commuting_app_mobile/dto/car/car_response.dart';
import 'package:commuting_app_mobile/dto/car/create_car_request.dart';
import 'package:commuting_app_mobile/dto/profile/profile_response.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class CarService {
  var tokenService = locator.get<TokenService>();

  Future createCar(CreateCarRequest createCarRequest) async {
    Dio dio = new Dio();
    Response response = await dio.post(BASE_URL + CAR_URL,
        data: createCarRequest,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return CarResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to save location');
    }
  }

  Future getCars() async {
    Dio dio = new Dio();
    Response response = await dio.get(BASE_URL + CAR_URL,
        options: tokenService.getAccessHeader());

    if (response.statusCode == 200) {
      return response.data
          .map<CarResponse>((json) => CarResponse.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to save location');
    }
  }
}
