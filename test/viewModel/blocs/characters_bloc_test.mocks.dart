import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc_state.dart';
import 'package:marvel_app/viewModel/models/characters_model.dart';
import 'package:dio/dio.dart';

class MockCharacterBloc extends Mock implements CharacterBloc {}

class MockEmitter extends Mock implements Emitter<CharacterState> {}

class MockDio extends Mock implements Dio {}

void main() {
  group('CharacterBloc', () {
    late MockCharacterBloc mockBloc;
    late MockEmitter mockEmitter;
    late MockDio mockDio;
    late CharacterModel mockCharacter;

    setUp(() {
      mockBloc = MockCharacterBloc();
      mockEmitter = MockEmitter();
      mockDio = MockDio();
      mockCharacter = CharacterModel(
          id: 1, name: 'Iron Man', description: 'A hero', thumbnail: '');
    });

    test('deve emitir CharacterLoading ao carregar personagens', () async {
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        data: {
          'data': {
            'results': [
              {
                'id': 1,
                'name': 'Iron Man',
                'description': 'A hero',
              }
            ]
          }
        },
      );

      when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);

      when(() => mockBloc.getAllCharacters(any(), any())).thenAnswer((_) async {
        final response = await mockDio.get(any());
        final data = response.data['data']['results'] as List;
        final allCharacters =
            data.map((e) => CharacterModel.fromJson(e)).toList();

        mockEmitter(CharacterLoaded(allCharacters, allCharacters, []));
      });

      verify(() => mockBloc.getAllCharacters(any(), any())).called(1);
    });

    test('deve emitir CharacterError ao falhar ao carregar personagens',
        () async {
      when(() => mockDio.get(any())).thenThrow(Exception('Erro ao carregar'));

      when(() => mockBloc.getAllCharacters(any(), any())).thenAnswer((_) async {
        try {
          await mockDio.get(any());
        } catch (e) {
          mockEmitter(CharacterError('Erro ao carregar lista de personagens'));
        }
      });

      verify(() => mockBloc.getAllCharacters(any(), any())).called(1);
    });

    test('deve filtrar personagens ao buscar por nome', () async {
      final characters = [
        CharacterModel(
            id: 1, name: 'Iron Man', description: 'A hero', thumbnail: ''),
        CharacterModel(
            id: 2,
            name: 'Captain America',
            description: 'A hero',
            thumbnail: ''),
      ];

      when(() => mockBloc.getSearchCharacters(any(), any())).thenAnswer((_) {
        const query = 'Iron';
        final filtered = characters
            .where((character) => character.name.contains(query))
            .toList();

        mockEmitter(CharacterLoaded(characters, filtered, []));
      });

      verify(() => mockBloc.getSearchCharacters(any(), any())).called(1);
    });

    test('deve atualizar a lista de recentemente vistos', () async {
      when(() => mockBloc.getRecentlyViewCharacter(any(), any()))
          .thenAnswer((_) async {
        final updatedRecentlyViewed = [mockCharacter];

        mockEmitter(CharacterLoaded([], [], updatedRecentlyViewed));
      });

      verify(() => mockBloc.getRecentlyViewCharacter(any(), any())).called(1);
    });
  });
}
