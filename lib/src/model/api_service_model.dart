abstract class ResponseModel<T> {
  
   T fromJson(Map<String, dynamic> json);
   Map<String, dynamic> toJson();
}

abstract class RequestModel {
   Map<String, dynamic> toJson();
}
