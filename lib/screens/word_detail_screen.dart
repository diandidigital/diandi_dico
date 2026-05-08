import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/word.dart';
import '../providers/dictionary_provider.dart';

class WordDetailScreen extends StatelessWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<DictionaryProvider>(
      builder: (context, provider, _) {
        // Récupère l'état le plus récent du mot
        final current = provider.words.firstWhere(
          (w) => w.id == word.id,
          orElse: () => word,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(current.word),
            actions: [
              IconButton(
                icon: Icon(
                  current.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: current.isFavorite
                      ? theme.colorScheme.primary
                      : null,
                ),
                tooltip: current.isFavorite
                    ? 'Retirer des favoris'
                    : 'Ajouter aux favoris',
                onPressed: () => provider.toggleFavorite(current),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mot principal
                Text(
                  current.word,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),

                // Catégorie
                if (current.category != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      current.category!,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                const Divider(),
                const SizedBox(height: 16),

                // Définition
                _Section(
                  icon: Icons.menu_book_outlined,
                  title: 'Définition',
                  content: current.definition,
                  theme: theme,
                ),

                // Exemple
                if (current.example != null && current.example!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _Section(
                    icon: Icons.format_quote_outlined,
                    title: 'Exemple',
                    content: current.example!,
                    theme: theme,
                    isQuote: true,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final ThemeData theme;
  final bool isQuote;

  const _Section({
    required this.icon,
    required this.title,
    required this.content,
    required this.theme,
    this.isQuote = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        isQuote
            ? Container(
                padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 3,
                    ),
                  ),
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : Text(
                content,
                style: theme.textTheme.bodyLarge,
              ),
      ],
    );
  }
}
