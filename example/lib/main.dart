import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:api_service/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(home: ApiServiceManagerInstance()));
}
// ignore_for_file: avoid_print

class ApiServiceManagerInstance extends StatefulWidget {
  const ApiServiceManagerInstance({Key? key}) : super(key: key);

  @override
  State<ApiServiceManagerInstance> createState() =>
      _ApiServiceManagerInstanceState();
}

class _ApiServiceManagerInstanceState extends State<ApiServiceManagerInstance> {
  @override
  void initState() {
    super.initState();
    instanceCreater();
  }

  instanceCreater() async {
    //if you want to use api_service first create instance
    //Why create instance first?
    //api_service package coding by api standarts so you have to setup instance first

    //Example
    // await ApiServiceManager().initInstance();
    // Example 2
    //You can use specific header for all request
    // await ApiServiceManager().initInstance(defaultHeader: {
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    // }, responseStandartStatusCodeCallBacks: {
    //   401: (result) {}
    // });
    // Example 3
    //You can use specific status code callbacks
    await ApiServiceManager().initInstance(defaultHeader: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }, responseStandartStatusCodeCallBacks: {
      401: (apiResult) async {
        print(apiResult['message']);
      },
      200: (apiResult) async {
        print(apiResult);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                ApiService api = ApiService();
                var result = await api.requestApi(
                  endPoint: 'https://reqres.in/api/users',
                  requestType: ApiServiceRequestModel.Get,
                );

                //if you set the token in manager
                // await ApiServiceManager()
                //     .setBearerToken(token: result['token']);
                //you can use like this
                // var result2 = await api.requestApi(
                //     endPoint: 'https://reqres.in/api/users',
                //     requestType: ApiServiceRequestModel.Get,
                //     session: true,
                //     jsonBody: true);
                //you already send token the api ,
                //if you want to send image or file the api you hace tu use multipart
                //all file extensions you can send only body field in api so 'photo' body fields part and sending file path
                // var result3 = await api.multiPartRequestApi(
                //   endPoint: 'https://reqres.in/api/users',
                //   fileParams: {
                //     'file': sendinfFile!.path,
                //   },
                // );
                //and you can also use xhr What is the xhr? xhr progress provide to your uploaded  file time
                //example
                // var result4 = await api.multiPartRequestApi(
                //     endPoint: 'https://reqres.in/api/users',
                //     fileParams: {'file': sendinfFile.path},
                //     totalLength: (fileTotalLength) {
                //       print(fileTotalLength);
                //     },
                //     loadedBytes: (loadedBytes) {
                //       print('you uploaded $loadedBytes bytes');
                //     },
                //     progress: (progressText) {
                //       //return like 100.00
                //       print(progressText);
                //     });
                //also you can create periodic request

                // PeriodicApiService().configurations(
                //   taskId: 'example',
                //   endPoint: 'https://reqres.in/api/users',
                //   requestType: ApiServiceRequestModel.Get,
                //   session: true,
                //   jsonBody: true,
                // );

                // //after you have to create
                // PeriodicApiService().create(
                //   'example',
                //   const Duration(seconds: 30),
                // );
                // //listen to data
                // StreamController<dynamic>? streamingResponse =
                //     await PeriodicApiService().listen('example');
                // if (streamingResponse != null) {
                //   Stream stream = streamingResponse.stream;
                //   stream.listen((apiresult) {
                //     print(apiresult);
                //   });
                // }
              },
              child: const Text('Send Request'),
            ),
          ],
        ),
      ),
    );
  }
}
