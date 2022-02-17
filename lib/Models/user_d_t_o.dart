/// user_id : "12084"
/// email : "test23@yopmail.com"
/// first_name : null
/// last_name : null
/// profile_pic : null
/// phone_number : null
/// access_token : "12084c3f93cf445b248511f8bd0cf9e39067f"
/// website_url : "https://maison.mywwwserver.in/?access_token=12084c3f93cf445b248511f8bd0cf9e39067f"

class UserDTO {
  UserDTO({
    String? userId,
    String? email,
    dynamic firstName,
    dynamic lastName,
    dynamic profilePic,
    dynamic phoneNumber,
    String? accessToken,
    String? websiteUrl,
  }) {
    _userId = userId;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
    _profilePic = profilePic;
    _phoneNumber = phoneNumber;
    _accessToken = accessToken;
    _websiteUrl = websiteUrl;
  }

  UserDTO.fromJson(dynamic json) {
    _userId = json['user_id'];
    _email = json['email'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _profilePic = json['profile_pic'];
    _phoneNumber = json['phone_number'];
    _accessToken = json['access_token'];
    _websiteUrl = json['website_url'];
  }
  String? _userId;
  String? _email;
  dynamic _firstName;
  dynamic _lastName;
  dynamic _profilePic;
  dynamic _phoneNumber;
  String? _accessToken;
  String? _websiteUrl;

  String? get userId => _userId;
  String? get email => _email;
  dynamic get firstName => _firstName;
  dynamic get lastName => _lastName;
  dynamic get profilePic => _profilePic;
  dynamic get phoneNumber => _phoneNumber;
  String? get accessToken => _accessToken;
  String? get websiteUrl => _websiteUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['email'] = _email;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['profile_pic'] = _profilePic;
    map['phone_number'] = _phoneNumber;
    map['access_token'] = _accessToken;
    map['website_url'] = _websiteUrl;
    return map;
  }
}
