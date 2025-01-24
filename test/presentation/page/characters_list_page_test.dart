import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc_events.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc_state.dart';
import 'package:marvel_app/views/presentation/pages/characters_list_page.dart';
import 'package:marvel_app/viewModel/models/characters_model.dart';

void main() {
  late CharacterBloc characterBloc;

  setUp(() {
    characterBloc = CharacterBloc();
  });

  tearDown(() {
    characterBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<CharacterBloc>.value(
        value: characterBloc,
        child: const CharacterListPage(),
      ),
    );
  }

  testWidgets('renders loading indicator when state is CharacterLoading',
      (WidgetTester tester) async {
    characterBloc.add(GetAllCharacters());
    await tester.pumpWidget(createWidgetUnderTest());
    characterBloc.emit(CharacterLoading());
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders character list when state is CharacterLoaded',
      (WidgetTester tester) async {
    final characters = [
      CharacterModel(
          id: 1,
          name: 'Spider-Man',
          thumbnail: 'https://example.com/spiderman.jpg',
          description: ''),
      CharacterModel(
          id: 2,
          name: 'Iron Man',
          thumbnail: 'https://example.com/ironman.jpg',
          description: ''),
    ];

    characterBloc.emit(CharacterLoaded(characters, characters, []));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('MARVEL CHARACTERS LIST'), findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget);
    expect(find.text('Iron Man'), findsOneWidget);
  });

  testWidgets('renders error message when state is CharacterError',
      (WidgetTester tester) async {
    characterBloc.emit(CharacterError('Erro ao carregar personagens'));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Erro ao carregar personagens'), findsOneWidget);
  });

  testWidgets('search field triggers SearchCharacters event',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.enterText(find.byType(TextField), 'Hulk');
    await tester.pump();
    expect(characterBloc.state, isA<CharacterLoading>());
  });
}
