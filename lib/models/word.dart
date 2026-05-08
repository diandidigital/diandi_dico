class Word {
  final int? id;
  final String word;
  final String definition;
  final String? example;
  final String? category;
  bool isFavorite;

  Word({
    this.id,
    required this.word,
    required this.definition,
    this.example,
    this.category,
    this.isFavorite = false,
  });

  Word copyWith({
    int? id,
    String? word,
    String? definition,
    String? example,
    String? category,
    bool? isFavorite,
  }) {
    return Word(
      id: id ?? this.id,
      word: word ?? this.word,
      definition: definition ?? this.definition,
      example: example ?? this.example,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'word': word,
        'definition': definition,
        'example': example,
        'category': category,
        'is_favorite': isFavorite ? 1 : 0,
      };

  factory Word.fromMap(Map<String, dynamic> map) => Word(
        id: map['id'] as int?,
        word: map['word'] as String,
        definition: map['definition'] as String,
        example: map['example'] as String?,
        category: map['category'] as String?,
        isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      );
}
