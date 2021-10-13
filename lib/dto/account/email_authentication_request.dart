/// email : "string"

class EmailAuthenticationRequest {
  String? _email;

  String? get email => _email;

  EmailAuthenticationRequest({
      String? email}){
    _email = email;
}

  EmailAuthenticationRequest.fromJson(dynamic json) {
    _email = json["email"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["email"] = _email;
    return map;
  }

}