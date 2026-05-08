import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/word.dart';
import 'sample_data.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'diandi_dico.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        definition TEXT NOT NULL,
        example TEXT,
        category TEXT,
        is_favorite INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_word ON words(word COLLATE NOCASE)
    ''');

    final batch = db.batch();
    for (final entry in sampleData) {
      batch.insert('words', entry);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Word>> searchWords(String query) async {
    final db = await database;
    final rows = query.trim().isEmpty
        ? await db.query('words', orderBy: 'word COLLATE NOCASE ASC')
        : await db.query(
            'words',
            where: 'word LIKE ?',
            whereArgs: ['${query.trim()}%'],
            orderBy: 'word COLLATE NOCASE ASC',
          );
    return rows.map(Word.fromMap).toList();
  }

  Future<List<Word>> getFavorites() async {
    final db = await database;
    final rows = await db.query(
      'words',
      where: 'is_favorite = 1',
      orderBy: 'word COLLATE NOCASE ASC',
    );
    return rows.map(Word.fromMap).toList();
  }

  Future<void> toggleFavorite(int id, bool value) async {
    final db = await database;
    await db.update(
      'words',
      {'is_favorite': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Word?> getWord(int id) async {
    final db = await database;
    final rows = await db.query('words', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Word.fromMap(rows.first);
  }
}
