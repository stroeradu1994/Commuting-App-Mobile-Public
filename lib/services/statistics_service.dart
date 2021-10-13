import 'package:commuting_app_mobile/dto/account/add_name_request.dart';
import 'package:commuting_app_mobile/dto/account/authorization_response.dart';
import 'package:commuting_app_mobile/dto/account/email_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/email_verification_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_verification_request.dart';
import 'package:commuting_app_mobile/dto/car/car_response.dart';
import 'package:commuting_app_mobile/dto/car/create_car_request.dart';
import 'package:commuting_app_mobile/dto/profile/profile_response.dart';
import 'package:commuting_app_mobile/services/service_wrapper.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';
import 'package:commuting_app_mobile/dto/statistics/statistics_response.dart';

class StatisticsService {
  var tokenService = locator.get<TokenService>();
  var serviceWrapper = locator.get<ServiceWrapper>();

  Future get() async {
    Dio dio = new Dio();
    var response = await serviceWrapper.handleApiRequest(dio.get(
        BASE_URL + STATISTICS_URL,
        options: tokenService.getAccessHeader()));
    return StatisticsResponse.fromJson(response);
  }
}
