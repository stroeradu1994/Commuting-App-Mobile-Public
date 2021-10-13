/// id : "402880007ab9d3a8017ab9d3d5950000"
/// firstName : null
/// lastName : null
/// email : "string"
/// phoneNumber : null
/// phoneNumberVerified : false

class AccountResponse {
  String? _id;
  dynamic? _firstName;
  dynamic? _lastName;
  String? _email;
  dynamic? _phoneNumber;
  bool? _phoneNumberVerified;

  String? get id => _id;
  dynamic? get firstName => _firstName;
  dynamic? get lastName => _lastName;
  String? get email => _email;
  dynamic? get phoneNumber => _phoneNumber;
  bool? get phoneNumberVerified => _phoneNumberVerified;

  AccountResponse({
      String? id, 
      dynamic? firstName, 
      dynamic? lastName, 
      String? email, 
      dynamic? phoneNumber, 
      bool? phoneNumberVerified}){
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phoneNumber = phoneNumber;
    _phoneNumberVerified = phoneNumberVerified;
}

  AccountResponse.fromJson(dynamic json) {
    _id = json["id"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
    _email = json["email"];
    _phoneNumber = json["phoneNumber"];
    _phoneNumberVerified = json["phoneNumberVerified"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["email"] = _email;
    map["phoneNumber"] = _phoneNumber;
    map["phoneNumberVerified"] = _phoneNumberVerified;
    return map;
  }

}