class AddFcmTokenRequest {
  String? _token;

  String? get token => _token;

  AddFcmTokenRequest({
      String? token}){
    _token = token;
}

  AddFcmTokenRequest.fromJson(dynamic json) {
    _token = json["token"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["token"] = _token;
    return map;
  }

}