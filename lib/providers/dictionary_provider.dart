import 'package:flutter/foundation.dart';
import '../db/database_helper.dart';
import '../models/word.dart';

class DictionaryProvider extends ChangeNotifier {
  final _db = DatabaseHelper();

  List<Word> _words = [];
  List<Word> _favorites = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Word> get words => _words;
  List<Word> get favorites => _favorites;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    await search('');
    await loadFavorites();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    _words = await _db.searchWords(query);
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    _favorites = await _db.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(Word word) async {
    if (word.id == null) return;
    final newValue = !word.isFavorite;
    await _db.toggleFavorite(word.id!, newValue);

    // Met à jour la liste principale
    final idx = _words.indexWhere((w) => w.id == word.id);
    if (idx != -1) {
      _words[idx] = _words[idx].copyWith(isFavorite: newValue);
    }

    // Recharge les favoris
    await loadFavorites();
    notifyListeners();
  }
}
