import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_app/viewModel/models/characters_model.dart';

import 'package:marvel_app/views/presentation/pages/characters_details_page.dart';
import 'package:mocktail/mocktail.dart';

// Mock para o modelo de personagem
class MockCharacterModel extends Mock implements CharacterModel {}

void main() {
  late MockCharacterModel mockCharacter;

  setUp(() {
    mockCharacter = MockCharacterModel();

    // Definindo valores mockados para o personagem
    when(() => mockCharacter.name).thenReturn('Iron Man');
    when(() => mockCharacter.description)
        .thenReturn('Genius, billionaire, playboy, philanthropist.');
    when(() => mockCharacter.thumbnail)
        .thenReturn('https://example.com/iron_man.jpg');
  });

  testWidgets('Deve exibir os detalhes do personagem corretamente',
      (WidgetTester tester) async {
    // Constrói a página com o personagem mockado
    await tester.pumpWidget(
      MaterialApp(
        home: CharacterDetailPage(character: mockCharacter),
      ),
    );

    // Verifica se a imagem do personagem está sendo exibida
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    // Verifica se o nome do personagem aparece na tela
    expect(find.text('Iron Man'), findsOneWidget);

    // Verifica se a biografia do personagem está correta
    expect(find.text('BIOGRAPHY'), findsOneWidget);
    expect(find.text('Genius, billionaire, playboy, philanthropist.'),
        findsOneWidget);

    // Verifica se o logo da Marvel está sendo exibido
    expect(
        find.byType(Image),
        findsNWidgets(
            2)); // Uma para a imagem do personagem e outra para o logo da Marvel

    // Simula o clique no botão de voltar
    await tester.tap(find.byIcon(Icons.back_hand_outlined));
    await tester.pumpAndSettle();

    // Verifica se a navegação foi realizada corretamente (pop do Navigator)
    expect(find.byType(CharacterDetailPage), findsNothing);
  });

  testWidgets('Deve ter AppBar com o logo da Marvel',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CharacterDetailPage(character: mockCharacter),
      ),
    );

    // Verifica se a AppBar contém o logo da Marvel
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
  });
}
