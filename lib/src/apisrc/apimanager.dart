import 'package:api_service/src/apisrc/logger.dart';
import 'package:api_service/src/model/manager_model.dart';
import 'package:logger/logger.dart';


class ApiServiceManager
    with
        CsrApiServiceHeaderModel,
        CsrApiServiceSessionModel,
        CsrApiServiceTimeOutModel,
        CsrApiServiceResponseStatusModel,
        ServiceLogger {
  static final ApiServiceManager _singleton = ApiServiceManager._internal();

  factory ApiServiceManager() {
    return _singleton;
  }

  ApiServiceManager._internal();
  CsrApiServiceHeaderModel? _header;
  CsrApiServiceHeaderModel? get getHeader => _header;
  Future<void> initInstance(
      {Map<String, String>? defaultHeader,
      int? timeOutDuration = 30,
      Map<int, Function(dynamic)>? responseStandartStatusCodeCallBacks}) async {
    _header = CsrApiServiceHeaderModel();
    _header!.setHeader(defaultHeader ??
        {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
    setTimeOut(timeOutDelay: timeOutDuration!);
    if (responseStandartStatusCodeCallBacks != null) {
      setStatusCodeCallBacks(responseStandartStatusCodeCallBacks);
    }

    logger = Logger(level: Level.info);
    logger.i('🍺🍺🍺🍺🍺  ApiServiceManager Created Succesfully 🍺🍺🍺🍺🍺');
    logger = Logger(level: Level.debug);
    logger.d('Default Header Set:${defaultHeader ?? header}');
    logger = Logger(level: Level.debug);
    logger.d(
        'Default Response Status Code CallBacks:${responseStandartStatusCodeCallBacks ?? getStatusCodeCallBacks}');
  }
}
