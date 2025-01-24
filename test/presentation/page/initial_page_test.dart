import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc_state.dart';
import 'package:marvel_app/views/presentation/pages/characters_list_page.dart';
import 'package:marvel_app/views/presentation/pages/initial_page.dart';
import 'package:mocktail/mocktail.dart';

class MockCharacterBloc extends Mock implements CharacterBloc {}

class MockEmitter extends Mock implements Emitter<CharacterState> {}

void main() {
  group('InitialPage', () {
    testWidgets(
        'deve exibir o logo e navegar para a página de personagens ao clicar',
        (WidgetTester tester) async {
      final mockBloc = MockCharacterBloc();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CharacterBloc>.value(
            value: mockBloc,
            child: const InitialPage(),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(
          find.byWidgetPredicate(
              (widget) => widget is Image && widget.image is AssetImage),
          findsOneWidget);

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(find.byType(CharacterListPage), findsOneWidget);
    });
  });
}
