import 'package:flutter/material.dart';

import 'omdb_api.dart';
import 'open_library_api.dart';
import 'pick.dart';
import 'pick_details.dart';

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<PickDetails> _future;

  @override
  void initState() {
    super.initState();
    final pick = widget.pick;
    _future = pick.isBook
        ? OpenLibraryApi().details(pick.externalId)
        : OmdbApi().details(pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pick = widget.pick;

    return Scaffold(
      appBar: AppBar(
        title: Text(pick.title.trim()),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: FutureBuilder<PickDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          final details = snapshot.data!;
          final imageUrl = details.imageUrl;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: imageUrl == null
                      ? Icon(
                          pick.isBook ? Icons.menu_book : Icons.movie,
                          size: 96,
                        )
                      : Image.network(
                          imageUrl,
                          height: 320,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stack) => Icon(
                            pick.isBook ? Icons.menu_book : Icons.movie,
                            size: 96,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                Text(details.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My note', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(pick.note),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Summary', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(details.summary),
              ],
            ),
          );
        },
      ),
    );
  }
}