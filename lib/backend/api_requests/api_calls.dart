import 'dart:convert';
import 'dart:typed_data';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class SendDataToWebCall {
  static Future<ApiCallResponse> call({
    String? batteryPerc = '',
    String? wardrobeHeight = '',
    String? sosEn = '',
    String? healthEn = '',
    String? lightEn = '',
  }) async {
    final ffApiRequestBody = '''
{
  "wardrobeHeight": "${wardrobeHeight}",
  "battery": "${batteryPerc}",
  "sosEn": "${sosEn}",
  "healthEn": "${healthEn}",
  "lightEn": "${lightEn}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'sendDataToWeb',
      apiUrl: 'https://rolandoquintana.pythonanywhere.com/send',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
