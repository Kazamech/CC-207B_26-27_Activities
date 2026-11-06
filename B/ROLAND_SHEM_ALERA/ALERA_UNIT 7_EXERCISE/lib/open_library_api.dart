import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'api_get.dart';
import 'book.dart';
import 'pick_details.dart';

class OpenLibraryApi {
  OpenLibraryApi({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final http.Response response;
    try {
      response = await client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('Open Library took too long to answer. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet and try again.');
    }
    if (response.statusCode != 200) {
      throw ApiException('Open Library answered ${response.statusCode}.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>;
    return [
      for (final doc in docs) Book.fromJson(doc as Map<String, dynamic>),
    ];
  }

  Future<PickDetails> details(String workId) async {
    final json = await getJsonMap(
      client,
      Uri.https('openlibrary.org', '/works/$workId.json'),
      'Open Library',
    );
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final covers = json['covers'] as List<dynamic>?;
    final coverId = covers == null || covers.isEmpty ? null : covers.first;
    return PickDetails(
      title: json['title'] as String? ?? '',
      summary: description,
      imageUrl: coverId == null
          ? null
          : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
    );
  }
}