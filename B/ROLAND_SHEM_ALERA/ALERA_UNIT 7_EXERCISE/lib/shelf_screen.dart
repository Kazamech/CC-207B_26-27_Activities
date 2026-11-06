import 'package:flutter/material.dart';

import 'books_tab.dart';
import 'movies_tab.dart';
import 'picks_tab.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          backgroundColor: theme.colorScheme.primaryContainer,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PicksTab(),
            BooksTab(),
            MoviesTab(),
          ],
        ),
      ),
    );
  }
}