import 'package:api_service/api_service.dart';

class EmptyResponse extends ResponseModel<EmptyResponse>{
  @override
  EmptyResponse fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}