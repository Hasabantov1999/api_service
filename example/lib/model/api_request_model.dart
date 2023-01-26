import 'package:api_service/api_service.dart';

class ExampleRequestModel extends RequestModel {
  ExampleRequestModel({
    this.phone,
  });

  String? phone;

  @override
  Map<String, dynamic> toJson() => {
        "phone": phone,
      };
}
