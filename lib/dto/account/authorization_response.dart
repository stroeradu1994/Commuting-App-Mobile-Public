/// accessToken : "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzdHJpbmdAYXNkYXNkLmNvbSIsImF1dGgiOiJVU0VSIiwidHlwZSI6IlJFRlJFU0giLCJleHAiOjE2MjU4MTYzNzF9.5nV3yAc990UX_0HWp_FtV1xR9561c43td-gH7PNN006gFxYVL4gOlXioBu_UjTyiyrWDC6cojHRP6C6TbNtBAw"
/// refreshToken : "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzdHJpbmdAYXNkYXNkLmNvbSIsImF1dGgiOiJVU0VSIiwidHlwZSI6IkFDQ0VTUyIsImV4cCI6MTYyMzM5NzE3MX0.G8DRzvlm1idlyz3KbHtTZ02-BAaWjyC2jA6yWLJ1eGt8d2wl1EB1lDxFVgRTm1dJTp5k4hCdzReCl_JaDst7Zg"

class AuthorizationResponse {
  String _accessToken;
  String _refreshToken;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  AuthorizationResponse(
      {required String accessToken, required String refreshToken})
      : _accessToken = accessToken,
        _refreshToken = refreshToken {}

  AuthorizationResponse.fromJson(dynamic json)
      : _accessToken = json["accessToken"],
        _refreshToken = json["refreshToken"] {}

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["accessToken"] = _accessToken;
    map["refreshToken"] = _refreshToken;
    return map;
  }
}
