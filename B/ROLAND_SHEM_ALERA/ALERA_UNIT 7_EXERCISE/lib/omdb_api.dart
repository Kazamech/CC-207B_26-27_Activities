import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'api_get.dart';
import 'movie.dart';
import 'pick_details.dart';

const omdbKey = String.fromEnvironment('OMDB_KEY');

class OmdbApi {
  OmdbApi({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;

  Future<List<Movie>> search(String query) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      's': query,
      'type': 'movie',
    });
    final http.Response response;
    try {
      response = await client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('OMDb took too long to answer. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet and try again.');
    }
    if (response.statusCode != 200) {
      throw ApiException('OMDb answered ${response.statusCode}.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }
    final results = json['Search'] as List<dynamic>;
    return [
      for (final result in results) Movie.fromJson(result as Map<String, dynamic>),
    ];
  }

  Future<PickDetails> details(String imdbId) async {
    final json = await getJsonMap(
      client,
      Uri.https('www.omdbapi.com', '/', {
        'apikey': omdbKey,
        'i': imdbId,
        'plot': 'short',
      }),
      'OMDb',
    );
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final poster = json['Poster'] as String?;
    return PickDetails(
      title: json['Title'] as String? ?? '',
      summary: json['Plot'] as String? ?? 'No plot yet.',
      imageUrl: poster == null || poster == 'N/A' ? null : poster,
    );
  }
}