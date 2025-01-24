import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_app/viewModel/models/characters_model.dart';

import 'package:marvel_app/views/presentation/pages/characters_details_page.dart';
import 'package:mocktail/mocktail.dart';

class MockCharacterModel extends Mock implements CharacterModel {}

void main() {
  late MockCharacterModel mockCharacter;

  setUp(() {
    mockCharacter = MockCharacterModel();

    when(() => mockCharacter.name).thenReturn('Iron Man');
    when(() => mockCharacter.description)
        .thenReturn('Genius, billionaire, playboy, philanthropist.');
    when(() => mockCharacter.thumbnail)
        .thenReturn('https://example.com/iron_man.jpg');
  });

  testWidgets('Deve exibir os detalhes do personagem corretamente',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CharacterDetailPage(character: mockCharacter),
      ),
    );

    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    expect(find.text('Iron Man'), findsOneWidget);

    expect(find.text('BIOGRAPHY'), findsOneWidget);
    expect(find.text('Genius, billionaire, playboy, philanthropist.'),
        findsOneWidget);

    expect(find.byType(Image), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.back_hand_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(CharacterDetailPage), findsNothing);
  });

  testWidgets('Deve ter AppBar com o logo da Marvel',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CharacterDetailPage(character: mockCharacter),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
  });
}
