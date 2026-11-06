import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'movie.dart';
import 'omdb_api.dart';

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  final OmdbApi api = OmdbApi();
  Timer? _debounce;
  Future<List<Movie>>? _results;

void _onChanged(String text) {
  _debounce?.cancel();
  _debounce = Timer(const Duration(milliseconds: 500), () {
    final query = text.trim();
    if (query.length < 3) return;
    setState(() {
      _results = api.search(query);
    });
  });
}
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _copyId(String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied $id')),
    );
  }

  Widget _poster(Movie movie) {
    final url = movie.poster;
    if (url == null) {
      return const SizedBox(width: 48, height: 72, child: Icon(Icons.movie));
    }
    return Image.network(
      url,
      width: 48,
      height: 72,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) =>
          const SizedBox(width: 48, height: 72, child: Icon(Icons.movie)),
    );
  }

  Widget _body() {
    if (_results == null) {
      return const Center(child: Text('Type at least 3 letters to search.'));
    }
    return FutureBuilder<List<Movie>>(
      future: _results,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        final movies = snapshot.data!;
        if (movies.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return ListTile(
              leading: _poster(movie),
              title: Text(movie.title),
              subtitle: Text(movie.year),
              trailing: IconButton(
                tooltip: 'Copy ID',
                icon: const Icon(Icons.copy),
                onPressed: () => _copyId(movie.imdbId),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'The OMDb key is missing.\n\n'
            'Run the app with:\n'
            'flutter run --dart-define=OMDB_KEY=your-key\n\n'
            'or put OMDB_KEY in cms.json and use --dart-define-from-file=cms.json',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _onChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search movies',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _body()),
      ],
    );
  }
}