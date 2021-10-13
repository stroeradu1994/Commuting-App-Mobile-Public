import 'package:commuting_app_mobile/dto/account/authorization_response.dart';
import 'package:commuting_app_mobile/services/prefs_service.dart';
import 'package:dio/dio.dart';

import 'locator.dart';

class TokenService {
  String? accessToken;
  String? refreshToken;

  String ACCESS_KEY = "ACCESS";
  String REFRESH_KEY = "REFRESH";
  String EMAIL_KEY = "EMAIL_VERIFIED";

  var prefsService = locator.get<PrefsService>();

  deleteTokens() {
    this.accessToken = null;
    this.refreshToken = null;
    prefsService.getPrefs().remove(ACCESS_KEY);
    prefsService.getPrefs().remove(REFRESH_KEY);
  }
  hasAccessToken() {
    return prefsService.getPrefs().containsKey(ACCESS_KEY);
  }

  retrieveTokens() async {
    accessToken = prefsService.getPrefs().getString(ACCESS_KEY);
    refreshToken = prefsService.getPrefs().getString(REFRESH_KEY);
  }

  saveTokens(AuthorizationResponse authorizationResponse) async {
    prefsService.getPrefs().setString(ACCESS_KEY, authorizationResponse.accessToken);
    accessToken = authorizationResponse.accessToken;
    prefsService.getPrefs().setString(REFRESH_KEY, authorizationResponse.refreshToken);
    refreshToken = authorizationResponse.refreshToken;
  }

  getAccessHeader() {
    return Options(
      headers: {
        'Authorization': 'Bearer ' + accessToken!,
      },
    );
  }

  getRefreshHeader() {
    return Options(
      headers: {
        'Authorization': 'Bearer ' + refreshToken!,
      },
    );
  }
}
