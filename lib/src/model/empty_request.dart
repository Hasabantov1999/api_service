import 'package:api_service/api_service.dart';

import 'package:api_service/src/model/request_model.dart';




class EmptyRequest extends RequestModel{
  @override
  Map<String, dynamic> toJson() {

    throw UnimplementedError();
  }
  
}