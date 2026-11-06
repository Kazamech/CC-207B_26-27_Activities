import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

Future<Map<String, dynamic>> getJsonMap(
  http.Client client,
  Uri uri,
  String service,
) async {
  final http.Response response;
  try {
    response = await client.get(uri).timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw ApiException('$service took too long to answer. Try again.');
  } on http.ClientException {
    throw const ApiException('No connection. Check your internet and try again.');
  }
  if (response.statusCode != 200) {
    throw ApiException('$service answered ${response.statusCode}.');
  }
  return jsonDecode(response.body) as Map<String, dynamic>;
}