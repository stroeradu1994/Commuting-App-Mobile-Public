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
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'locator.dart';

class ServiceWrapper {

  var notificationService = locator.get<NotificationService>();

  handleApiRequest(Future<Response> request) async {
    try {
      Dio dio = new Dio();
      Response response = await request;

      if (response.statusCode == 200) {
        return response.data;
      } else {
        notificationService.showSnackBar(response.data);
        return null;
      }
    } on DioError catch (e) {
      notificationService.showSnackBar(e.response!.data["message"]);
      return null;
    }

  }
}
