
import 'package:shared_preferences/shared_preferences.dart';

class CsrApiServiceSessionModel {
  Future<void> setBearerToken({required String token}) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString('_csrBearerToken', 'Bearer $token');
  }

  Future<String?> get getBearerToken async {
    final instance = await SharedPreferences.getInstance();

    return instance.getString('_csrBearerToken');
  }
}

class CsrApiServiceTimeOutModel {
  Future<void> setTimeOut({required int timeOutDelay }) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setInt('_csrTimeoutDuration', timeOutDelay);
  }

  Future<int?> get getTimeOut async {
    final instance = await SharedPreferences.getInstance();

    return instance.getInt('_csrTimeoutDuration');
  }
}

class CsrApiServiceHeaderModel {
   Map<String, String> _header = {};
   void setHeader(Map<String, String> header) {
    _header = header;
  }

   Map<String, String> get header => _header;
}

class CsrApiServiceResponseStatusModel {
   Map<int, Function (dynamic)> _statusCode = {};
   void setStatusCodeCallBacks(Map<int, Function (dynamic)> statusCode) {
    _statusCode = statusCode;
  }

   Map<int, Function (dynamic)> get getStatusCodeCallBacks => _statusCode;
}
