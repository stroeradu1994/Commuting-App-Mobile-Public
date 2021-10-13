/// code : "0"
/// phoneNumber : "string"

class PhoneNumberVerificationRequest {
  String? _code;
  String? _phoneNumber;

  String? get code => _code;
  String? get phoneNumber => _phoneNumber;

  PhoneNumberVerificationRequest({
      String? code, 
      String? phoneNumber}){
    _code = code;
    _phoneNumber = phoneNumber;
}

  PhoneNumberVerificationRequest.fromJson(dynamic json) {
    _code = json["code"];
    _phoneNumber = json["phoneNumber"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["phoneNumber"] = _phoneNumber;
    return map;
  }

}