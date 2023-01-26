import 'dart:async';

import 'package:api_service/api_service.dart';
import 'package:api_service/src/apisrc/logger.dart';
import 'package:api_service/src/apisrc/periodicservice_model/periodic_Service_handler.dart';
import 'package:api_service/src/apisrc/periodicservice_model/periodic_service_model.dart';
import 'package:logger/logger.dart';

class PeriodicApiService with  PeriodicServiceModel {
  static final PeriodicApiService _singleton = PeriodicApiService._internal();

  factory PeriodicApiService() {
    return _singleton;
  }

  PeriodicApiService._internal();

  Future<void> configurations({
    required String taskId,
    Map<String, String>? params,
    bool? session = false,
    required String endPoint,
    Object? body,
    bool? jsonBody = false,
    Map<String, String>? headers,
    required ApiServiceRequestModel requestType,
    Map<int, Function(dynamic)>? statusCodeParams,
  }) async {
    addAll(
      {
        taskId: {
          'params': params,
          'session': session,
          'endpoint': endPoint,
          'body': body,
          'jsonBody': jsonBody,
          'headers': headers,
          'requestType': requestType,
          'statusCodeParams': statusCodeParams
        },
      },
    );
  }

  Future<void> create(String taskId, Duration duration) async {
    if (!getTaskStatusListener.containsKey(taskId) &&
        getConfigurationWithTaskId.containsKey(taskId)) {
      Logger logger = Logger(level: Level.warning);
      logger.w('You already have this taskId so you cant create same taskId');
    } else {
      PeriodicServiceHandler periodicServiceHandler = PeriodicServiceHandler(
          taskId: taskId,
          apiConfigurations: getConfigurationWithTaskId[taskId],
          duration: duration);
    }
  }

  Future<void> stop(String taskId) async {
    if (getTaskStatusListener.containsKey(taskId)) {
      if (getTaskStatusListener[taskId]!.stream.isBroadcast) {
        getTaskStatusListener[taskId]!.close();
      }
    }
  }

  Future<StreamController?> listen(String taskId) async =>
      getTaskStatusListener[taskId];
}
