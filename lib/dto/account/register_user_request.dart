/// email : "string@asdasd.com"
/// firstName : "string"
/// lastName : "string"
/// password : "string"

class RegisterUserRequest {
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _password;

  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get password => _password;

  RegisterUserRequest({
      String? email,
      String? firstName,
      String? lastName,
      String? password}){
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
    _password = password;
}

  RegisterUserRequest.fromJson(dynamic json) {
    _email = json["email"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
    _password = json["password"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["email"] = _email;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["password"] = _password;
    return map;
  }

}