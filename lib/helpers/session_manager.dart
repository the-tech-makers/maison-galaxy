import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final String auth_token = "token";
  final String url = "website_url";

  Future<bool> checkData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(this.url);
  }

//set data into shared preferences like this
  Future<void> setAuthToken(String auth_token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.auth_token, auth_token);
  }

  Future<void> setUrl(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.url, url);
  }

//get value from shared preferences
  Future<String?> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? url;
    url = pref.getString(this.url) ?? null;
    return url;
  }

  Future<String?> getUrl() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? auth_token;
    auth_token = pref.getString(this.auth_token) ?? null;
    return auth_token;
  }
}
