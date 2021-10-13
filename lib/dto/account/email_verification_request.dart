/// code : "7955"
/// email : "string"

class EmailVerificationRequest {
  String? _code;
  String? _email;

  String? get code => _code;
  String? get email => _email;

  EmailVerificationRequest({
      String? code, 
      String? email}){
    _code = code;
    _email = email;
}

  EmailVerificationRequest.fromJson(dynamic json) {
    _code = json["code"];
    _email = json["email"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["email"] = _email;
    return map;
  }

}