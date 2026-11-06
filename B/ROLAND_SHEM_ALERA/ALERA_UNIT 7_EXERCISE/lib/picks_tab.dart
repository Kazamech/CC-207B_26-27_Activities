import 'package:flutter/material.dart';

import 'pick.dart';
import 'pick_detail_screen.dart';
import 'pick_source.dart';

class PicksTab extends StatefulWidget {
  const PicksTab({super.key});

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab> {
  final PickSource source = ContentfulPickSource();
  late Future<List<Pick>> _future;

  @override
  void initState() {
    super.initState();
    _future = source.fetchPicks();
  }

  Future<void> _refresh() async {
    final next = source.fetchPicks();
    setState(() {
      _future = next;
    });
    try {
      await next;
    } catch (_) {}
  }

  Widget _message(IconData icon, String text, {Widget? action}) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 120, left: 24, right: 24),
          child: Column(
            children: [
              Icon(icon, size: 48),
              const SizedBox(height: 16),
              Text(text, textAlign: TextAlign.center),
              if (action != null) ...[
                const SizedBox(height: 16),
                action,
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _message(
              Icons.cloud_off,
              '${snapshot.error}',
              action: FilledButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            );
          }
          final picks = snapshot.data!;
          if (picks.isEmpty) {
            return _message(Icons.favorite_border, 'No picks yet.');
          }
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];
              return ListTile(
                leading: Icon(pick.isBook ? Icons.menu_book : Icons.movie),
                title: Text(pick.title.trim()),
                subtitle: Text(
                  pick.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PickDetailScreen(pick: pick),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}