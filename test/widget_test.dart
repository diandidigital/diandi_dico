import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:translatehub/main.dart';
import 'package:translatehub/providers/dictionary_provider.dart';

void main() {
  testWidgets('App démarre et affiche le titre', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => DictionaryProvider(),
        child: const DiandIDicoApp(),
      ),
    );
    await tester.pump();
    expect(find.text('TranslateHub'), findsWidgets);
  });
}
