import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'book.dart';
import 'open_library_api.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final OpenLibraryApi api = OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

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

  Widget _cover(Book book) {
    final url = book.coverUrl;
    if (url == null) {
      return const SizedBox(width: 48, height: 72, child: Icon(Icons.menu_book));
    }
    return Image.network(
      url,
      width: 48,
      height: 72,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) =>
          const SizedBox(width: 48, height: 72, child: Icon(Icons.menu_book)),
    );
  }

  Widget _body() {
    if (_results == null) {
      return const Center(child: Text('Type at least 3 letters to search.'));
    }
    return FutureBuilder<List<Book>>(
      future: _results,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        final books = snapshot.data!;
        if (books.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            final author =
                book.authors.isEmpty ? 'Unknown author' : book.authors.first;
            final year = book.year == null ? '' : ' · ${book.year}';
            return ListTile(
              leading: _cover(book),
              title: Text(book.title),
              subtitle: Text('$author$year'),
              trailing: IconButton(
                tooltip: 'Copy ID',
                icon: const Icon(Icons.copy),
                onPressed: () => _copyId(book.workId),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _onChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search books',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _body()),
      ],
    );
  }
}