import 'package:http_interceptor/http_interceptor.dart';

import '../helpers/session_manager.dart';

class HttpApiInterceptor implements InterceptorContract {
  late String _token;
  SessionManager sessionManager = SessionManager();
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      await getToken();

      data.headers["Content-Type"] = "application/json";
      // data.headers["Authorization"] = 'bearer $_token';
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;

  Future<void> getToken() async {
    Future<String?> authToken = sessionManager.getAuthToken();
    await authToken.then((data) {
      _token = data!;
      print("authToken " + data.toString());
    }, onError: (e) {
      print(e);
    });
  }
}
