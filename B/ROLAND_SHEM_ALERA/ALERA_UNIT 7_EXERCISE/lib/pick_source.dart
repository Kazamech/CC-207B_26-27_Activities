import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'pick.dart';

const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  ContentfulPickSource({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (cmsSpace.isEmpty || cmsToken.isEmpty) {
      throw const ApiException(
        'The CMS values are missing. Run with --dart-define-from-file=cms.json',
      );
    }
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$cmsSpace/environments/master/entries',
      {'content_type': 'pick', 'order': 'sys.createdAt', 'limit': '100'},
    );
    final http.Response response;
    try {
      response = await client
          .get(uri, headers: {'Authorization': 'Bearer $cmsToken'})
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('Contentful took too long to answer. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet and try again.');
    }
    final code = response.statusCode;
    if (code != 200) {
      throw ApiException(switch (code) {
        401 || 403 => 'Contentful refused the request ($code). Check your token.',
        404 => 'Contentful could not find the picks (404). Check the space and the content type name.',
        >= 500 => 'Contentful is having problems ($code). Try again later.',
        _ => 'Contentful answered $code.',
      });
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>;
    return [
      for (final item in items)
        Pick(
          id: item['sys']['id'] as String,
          title: item['fields']['title'] as String? ?? '',
          kind: item['fields']['kind'] as String? ?? '',
          externalId: item['fields']['externalId'] as String? ?? '',
          note: item['fields']['note'] as String? ?? '',
        ),
    ];
  }
}