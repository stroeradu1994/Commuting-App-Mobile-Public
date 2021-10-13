/// firstName : "string"
/// lastName : "string"

class AddNameRequest {
  String? _firstName;
  String? _lastName;

  String? get firstName => _firstName;
  String? get lastName => _lastName;

  AddNameRequest({
      String? firstName, 
      String? lastName}){
    _firstName = firstName;
    _lastName = lastName;
}

  AddNameRequest.fromJson(dynamic json) {
    _firstName = json["firstName"];
    _lastName = json["lastName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    return map;
  }

}