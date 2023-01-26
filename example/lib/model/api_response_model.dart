

import 'package:api_service/api_service.dart';

class ExampleModel extends ResponseModel {
  ExampleModel({
    this.login,
    this.password,
    this.token,
  });

  String? login;
  String? password;
  String? token;
   @override
  ExampleModel fromJson(Map<String, dynamic> json) => ExampleModel(
        login: json["login"],
        password: json["password"],
        token: json["token"],
      );
  @override
  Map<String, dynamic> toJson() => {
        "login": login,
        "password": password,
        "token": token,
      };
}
