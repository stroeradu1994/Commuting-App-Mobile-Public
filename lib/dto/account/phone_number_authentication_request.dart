/// phoneNumber : "string"

class PhoneNumberAuthenticationRequest {
  String? _phoneNumber;

  String? get phoneNumber => _phoneNumber;

  PhoneNumberAuthenticationRequest({
      String? phoneNumber}){
    _phoneNumber = phoneNumber;
}

  PhoneNumberAuthenticationRequest.fromJson(dynamic json) {
    _phoneNumber = json["phoneNumber"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["phoneNumber"] = _phoneNumber;
    return map;
  }

}