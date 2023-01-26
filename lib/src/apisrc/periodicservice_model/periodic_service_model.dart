import 'dart:async';

class PeriodicServiceModel {
  Map<String, dynamic> _configurationsWithTaskId = {};
  void setStatusCodeCallBacks(Map<String, dynamic> taskConfigurations) {
    _configurationsWithTaskId = taskConfigurations;
  }

  Map<String, dynamic> get getConfigurationWithTaskId =>
      _configurationsWithTaskId;
  void addAll(Map<String, dynamic> taskConfiguration) =>
      _configurationsWithTaskId.addAll(taskConfiguration);
  Map<String, StreamController<dynamic>> _taskStatusListener = {};
  void setStatusListener(Map<String, StreamController<dynamic>> listener) {
    _taskStatusListener = listener;
  }

  Map<String, StreamController<dynamic>> get getTaskStatusListener =>
      _taskStatusListener;
  void addStatusListener(Map<String, StreamController<dynamic>> listener) =>
      _configurationsWithTaskId.addAll(_taskStatusListener);
}
