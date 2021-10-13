import 'package:commuting_app_mobile/dto/account/add_name_request.dart';
import 'package:commuting_app_mobile/dto/account/authorization_response.dart';
import 'package:commuting_app_mobile/dto/account/email_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/email_verification_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_authentication_request.dart';
import 'package:commuting_app_mobile/dto/account/phone_number_verification_request.dart';
import 'package:commuting_app_mobile/dto/car/car_response.dart';
import 'package:commuting_app_mobile/dto/car/create_car_request.dart';
import 'package:commuting_app_mobile/dto/profile/profile_response.dart';
import 'package:commuting_app_mobile/services/notification_service.dart';
import 'package:commuting_app_mobile/services/token_service.dart';
import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class MatchService {
  var tokenService = locator.get<TokenService>();
  var notificationService = locator.get<NotificationService>();

  Future match(String id) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.post(
          BASE_URL + MATCH_URL + '/' + id + '/match',
          options: tokenService.getAccessHeader());

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to save location');
      }
    } on DioError catch (e) {
      notificationService.showSnackBar(e.toString());
      return null;
    }
  }

  Future unmatch(String id) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.post(
          BASE_URL + MATCH_URL + '/' + id + '/unmatch',
          options: tokenService.getAccessHeader());

      if (response.statusCode == 200) {
        return "response.data";
      } else {
        throw Exception('Failed to save location');
      }
    } on DioError catch (e) {
      notificationService.showSnackBar(e.response!.data["message"]);
      return null;
    }
  }
}
