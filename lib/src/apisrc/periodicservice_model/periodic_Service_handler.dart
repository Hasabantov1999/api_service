// ignore_for_file: file_names, constant_identifier_names, non_constant_identifier_names, prefer_initializing_formals

import 'dart:async';

import 'package:api_service/api_service.dart';
import 'package:logger/logger.dart';

class PeriodicServiceHandler {
  PeriodicServiceHandler(
      {required String taskId,
      required Map<String, dynamic> apiConfigurations,
      required Duration duration}) {
    Logger logger = Logger(
      level: Level.info,
    );
    logger.i('Periodic Timer Started  TaskId:$taskId');
    this.taskId = taskId;
    this.apiConfigurations = apiConfigurations;
    DEFAULT_INTERVAL = duration;
    checkInterval = duration;
    _statusController.onListen = () {
      _maybeEmitStatusUpdate();
    };

    _statusController.onCancel = () {
      Logger logger = Logger(
        level: Level.debug,
      );
      logger.d('Periodic Timer Stopped TaskId:$taskId');
      _timerHandle?.cancel();
      _lastStatus = null;
    };
  }
  late Map<String, dynamic> apiConfigurations;
  late String taskId;
  final StreamController<dynamic> _statusController =
      StreamController<dynamic>.broadcast();

  Future<void> _maybeEmitStatusUpdate([
    Timer? timer,
  ]) async {
    _timerHandle?.cancel();
    timer?.cancel();

    final dynamic currentResponse = await getResult;

    if (_lastStatus != currentResponse && _statusController.hasListener) {
      _statusController.add(currentResponse);
    }

    if (!_statusController.hasListener) return;
    _timerHandle = Timer(checkInterval!, _maybeEmitStatusUpdate);

    _lastStatus = currentResponse;
  }

  Duration? DEFAULT_INTERVAL;
  Duration? checkInterval;
  dynamic _lastStatus;
  Stream<dynamic> get onStatusChange => _statusController.stream;

  bool get hasListeners => _statusController.hasListener;
  Timer? _timerHandle;
  Future<dynamic> get getData async  {
    final Completer<dynamic> result = Completer<dynamic>();
    ApiService api = ApiService();
    var res = await api.requestApi(
      endPoint: apiConfigurations[taskId]['endPoint'],
      requestType: apiConfigurations[taskId]['requestType'],
      params: apiConfigurations[taskId]['params'],
      session: apiConfigurations[taskId]['session'],
      headers: apiConfigurations[taskId]['headers'],
      body: apiConfigurations[taskId]['body'],
      statusCodeParams: apiConfigurations[taskId]['statusCodeParams'],
      parseModel: apiConfigurations[taskId]['parseModel']

    );
    result.complete(res);
    return result.future;
  }

  Future<dynamic> get getResult async {
    return await getData;
  }
}
