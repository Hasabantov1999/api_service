// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';

import 'package:api_service/src/apisrc/apimanager.dart';
import 'package:api_service/src/apisrc/logger.dart';
import 'package:api_service/src/model/request_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiService with ServiceLogger {
  bool clientIsActive = false;
  Future<dynamic> requestApi(
      {Map<String, String>? params,
      bool? session = false,
      required String endPoint,
      Object? body,
      bool? jsonBody = false,
      Map<String, String>? headers,
      required ApiServiceRequestModel requestType,
      Map<int, Function(dynamic)>? statusCodeParams}) async {
    try {
      var client = http.Client();
      clientIsActive = true;
      int? timeOutDelay = await ApiServiceManager().getTimeOut;
      Future.delayed(Duration(seconds: timeOutDelay!), () async {
        if (clientIsActive) {
          client.close();
          return null;
        }
      });

      String? bearerToken = await ApiServiceManager().getBearerToken;
      if (session!) {
        if (bearerToken == null) {
          logger = Logger(level: Level.error);
          logger.e('Your session token returned null');
          return;
        }
      }

      if (ApiServiceManager().getHeader == null) {
        logger = Logger(level: Level.error);
        logger.e('instance error: Please init ApiServiceManager instance');
        return;
      }

      Map<String, String> standartHeader =
          ApiServiceManager().getHeader!.header;

      if (headers == null && session == true) {
        standartHeader = {'Authorization': bearerToken!};
      } else if (headers != null && session == true) {
        standartHeader = {'Authorization': bearerToken!};
        standartHeader.addAll(headers);
      } else if (headers != null && session == false) {
        standartHeader.addAll(headers);
      }

      var url = Uri.parse(endPoint);

      if (params != null) {
        String queryString = Uri(queryParameters: params).query;
        url = Uri.parse(endPoint + "?" + queryString);
      }

      http.Response? response;

      switch (requestType) {
        case ApiServiceRequestModel.Get:
          response = await client.get(url, headers: standartHeader);
          break;
        case ApiServiceRequestModel.Post:
          response =
              await client.post(url, body: body, headers: standartHeader);
          break;
        case ApiServiceRequestModel.Delete:
          response =
              await client.delete(url, body: body, headers: standartHeader);
          break;
        case ApiServiceRequestModel.Put:
          response = await client.put(url, body: body, headers: standartHeader);
          break;
        case ApiServiceRequestModel.Patch:
          response =
              await client.patch(url, body: body, headers: standartHeader);
          break;
        default:
          response = await client.get(url, headers: standartHeader);
          break;
      }

      var result = json.decode(response.body);

      logger = Logger(level: Level.debug);
      logger.d('Header:$standartHeader');
      logger.d('End Point:$url');
      logger.d('StatusCode:${response.statusCode}');
      logger.d('Request Type:$requestType');

      return await _statusCodeController(
          statusCode: response.statusCode,
          result: result,
          jsonBody: jsonBody!,
          response: response);
    } catch (ex, stackTrace) {
      clientIsActive = false;
      logger = Logger(level: Level.error);
      logger.e(
        'You got an error while submitting the request.',
        [ex, stackTrace],
      );
    } finally {
      clientIsActive = false;
    }
  }

  Future<dynamic> multiPartRequestApi({
    Map<String, String>? params,
    bool? session = false,
    required String endPoint,
    required Map<String, String> fileParams,
    Object? body,
    bool? jsonBody = false,
    Map<String, String>? headers,
    Map<int, Function(dynamic)>? statusCodeParams,
    bool? xhr = false,
    ValueChanged<int>? totalLength,
    ValueChanged<String>? progress,
    ValueChanged<int>? loadedBytes,
  }) async {
    try {
      clientIsActive = true;

      String? bearerToken = await ApiServiceManager().getBearerToken;
      if (session!) {
        if (bearerToken == null) {
          logger = Logger(level: Level.error);
          logger.d('Your session token returned null');
          return;
        }
      }
      if (ApiServiceManager().getHeader == null) {
        logger = Logger(level: Level.error);
        logger.d('instance error: Please init ApiServiceManager instance');
        return;
      }
      Map<String, String> standartHeader =
          ApiServiceManager().getHeader!.header;
      if (headers == null && session == true) {
        standartHeader = {'Authorization': bearerToken!};
      } else if (headers != null && session == true) {
        standartHeader = {'Authorization': bearerToken!};
        standartHeader.addAll(headers);
      } else if (headers != null && session == false) {
        standartHeader.addAll(headers);
      }

      var url = Uri.parse(endPoint);
      if (params != null) {
        String queryString = Uri(queryParameters: params).query;
        url = Uri.parse(endPoint + "?" + queryString);
      }
      http.MultipartRequest? request = http.MultipartRequest('POST', url);

      fileParams.forEach((key, value) {
        request.files.add(
          http.MultipartFile(
            key,
            File(value).readAsBytes().asStream(),
            File(value).lengthSync(),
            filename: value.split("/").last,
          ),
        );
      });
      request.headers.addAll(standartHeader);
      http.StreamedResponse mExexutaion = await request.send();

      if (xhr!) {
        if (totalLength != null) {
          totalLength(mExexutaion.contentLength!);
        }
        int downloadLength = 0;
        mExexutaion.stream.listen((newBytes) {
          downloadLength += newBytes.length;
          if (progress != null) {
            progress(
                ((downloadLength / (mExexutaion.contentLength as int)) * 100)
                    .toStringAsFixed(2));
          }
          if (loadedBytes != null) {
            loadedBytes(downloadLength);
          }
        }, onDone: () {
          logger = Logger(level: Level.info);
          logger.d('File uploaded succesfully');
        }, onError: () {
          logger = Logger(level: Level.error);
          logger.d('Error: File cant uploaded');
          logger = Logger(level: Level.debug);
          logger.d('End Point:$url');
          logger.d('StatusCode:${mExexutaion.statusCode}');
          logger.d('Request Type:POST');
        });
      }
      final response = await http.Response.fromStream(mExexutaion);
      var result = json.decode(response.body);
      return await _statusCodeController(
          statusCode: response.statusCode,
          result: result,
          jsonBody: jsonBody!,
          response: response);
    } catch (ex, stackTrace) {
      logger = Logger(level: Level.error);
      logger.e(
        'You got an error while submitting the request.',
        [ex, stackTrace],
      );
    } finally {
      clientIsActive = false;
    }
  }

  Future<dynamic> _statusCodeController(
      {required int statusCode,
      required dynamic result,
      required bool jsonBody,
      required http.Response response,
      Map<int, Function(dynamic)>? statusCodeParams}) async {
    switch (response.statusCode) {
      case 200:
      if (statusCodeParams == null) {
          if (ApiServiceManager().getStatusCodeCallBacks.containsKey(200)) {
            ApiServiceManager().getStatusCodeCallBacks[200]!(result);
          }
        } else {
          if (statusCodeParams.containsKey(200)) {
            statusCodeParams[200]!;
          } else {
            if (ApiServiceManager().getStatusCodeCallBacks.containsKey(200)) {
              ApiServiceManager().getStatusCodeCallBacks[200]!(result);
            }
          }
        }
        return jsonBody ? result : response.body;
        
      case 401:
        if (statusCodeParams == null) {
          if (ApiServiceManager().getStatusCodeCallBacks.containsKey(401)) {
            ApiServiceManager().getStatusCodeCallBacks[401]!(result);
          }
        } else {
          if (statusCodeParams.containsKey(401)) {
            statusCodeParams[401]!;
          } else {
            if (ApiServiceManager().getStatusCodeCallBacks.containsKey(401)) {
              ApiServiceManager().getStatusCodeCallBacks[401]!(result);
            }
          }
        }
        return null;
      case 404:
        if (statusCodeParams == null) {
          if (ApiServiceManager().getStatusCodeCallBacks.containsKey(404)) {
            ApiServiceManager().getStatusCodeCallBacks[404]!(response.body)(result);
          }
        } else {
          if (statusCodeParams.containsKey(404)) {
            statusCodeParams[404]!;
          } else {
            if (ApiServiceManager().getStatusCodeCallBacks.containsKey(404)) {
              ApiServiceManager().getStatusCodeCallBacks[404]!(result);
            }
          }
        }
        return null;
      case 405:
        if (statusCodeParams == null) {
          if (ApiServiceManager().getStatusCodeCallBacks.containsKey(405)) {
            ApiServiceManager().getStatusCodeCallBacks[405]!(result);
          }
        } else {
          if (statusCodeParams.containsKey(405)) {
            statusCodeParams[405]!;
          } else {
            if (ApiServiceManager().getStatusCodeCallBacks.containsKey(405)) {
              ApiServiceManager().getStatusCodeCallBacks[405]!(result);
            }
          }
        }
        return null;
      case 422:
        if (statusCodeParams == null) {
          if (ApiServiceManager().getStatusCodeCallBacks.containsKey(422)) {
            ApiServiceManager().getStatusCodeCallBacks[422]!(result);
          }
        } else {
          if (statusCodeParams.containsKey(422)) {
            statusCodeParams[422]!;
          } else {
            if (ApiServiceManager().getStatusCodeCallBacks.containsKey(422)) {
              ApiServiceManager().getStatusCodeCallBacks[422]!(result);
            }
          }
        }
        return null;
      case 500:
        if (statusCodeParams == null) {
          if (ApiServiceManager().getStatusCodeCallBacks.containsKey(500)) {
            ApiServiceManager().getStatusCodeCallBacks[500]!(result);
          }
        } else {
          if (statusCodeParams.containsKey(500)) {
            statusCodeParams[500]!;
          } else {
            if (ApiServiceManager().getStatusCodeCallBacks.containsKey(500)) {
              ApiServiceManager().getStatusCodeCallBacks[500]!(result);
            }
          }
        }
        return null;
      default:
        return null;
    }
  }
}
