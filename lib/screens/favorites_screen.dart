import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dictionary_provider.dart';
import '../widgets/word_tile.dart';
import 'word_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DictionaryProvider>(
      builder: (context, provider, _) {
        final favorites = provider.favorites;

        if (favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun favori pour l\'instant',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Appuyez sur l\'icône 🔖 pour sauvegarder un mot.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: favorites.length,
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 16),
          itemBuilder: (context, index) {
            final word = favorites[index];
            return WordTile(
              word: word,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WordDetailScreen(word: word),
                ),
              ),
              onFavoriteToggle: () => provider.toggleFavorite(word),
            );
          },
        );
      },
    );
  }
}
