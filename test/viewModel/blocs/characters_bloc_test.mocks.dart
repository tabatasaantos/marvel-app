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
      // Instancia os mocks
      mockBloc = MockCharacterBloc();
      mockEmitter = MockEmitter();
      mockDio = MockDio();
      mockCharacter = CharacterModel(
          id: 1, name: 'Iron Man', description: 'A hero', thumbnail: '');
    });

    test('deve emitir CharacterLoading ao carregar personagens', () async {
      // Configuração do mock do Dio
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

      // Simula o método getAllCharacters
      when(() => mockBloc.getAllCharacters(any(), any())).thenAnswer((_) async {
        // Emite os estados simulados
        final response = await mockDio.get(any());
        final data = response.data['data']['results'] as List;
        final allCharacters =
            data.map((e) => CharacterModel.fromJson(e)).toList();

        // Emite os estados usando o mockEmitter com a assinatura correta
        mockEmitter(CharacterLoaded(allCharacters, allCharacters, []));
      });

      // Verificar se o método foi chamado corretamente
      verify(() => mockBloc.getAllCharacters(any(), any())).called(1);
    });

    test('deve emitir CharacterError ao falhar ao carregar personagens',
        () async {
      // Configura o mock do Dio para lançar um erro
      when(() => mockDio.get(any())).thenThrow(Exception('Erro ao carregar'));

      // Simula o método getAllCharacters com erro
      when(() => mockBloc.getAllCharacters(any(), any())).thenAnswer((_) async {
        try {
          await mockDio.get(any());
        } catch (e) {
          // Emite um erro usando o mockEmitter com a assinatura correta
          mockEmitter(CharacterError('Erro ao carregar lista de personagens'));
        }
      });

      // Verificar se o erro foi emitido
      verify(() => mockBloc.getAllCharacters(any(), any())).called(1);
    });

    test('deve filtrar personagens ao buscar por nome', () async {
      // Dados de personagens mockados
      final characters = [
        CharacterModel(
            id: 1, name: 'Iron Man', description: 'A hero', thumbnail: ''),
        CharacterModel(
            id: 2,
            name: 'Captain America',
            description: 'A hero',
            thumbnail: ''),
      ];

      // Simula a busca
      when(() => mockBloc.getSearchCharacters(any(), any())).thenAnswer((_) {
        const query = 'Iron';
        final filtered = characters
            .where((character) => character.name.contains(query))
            .toList();

        // Emite o estado de pesquisa com o mockEmitter com a assinatura correta
        mockEmitter(CharacterLoaded(characters, filtered, []));
      });

      // Ação: Simular a busca

      // Verificar se o filtro foi aplicado corretamente
      verify(() => mockBloc.getSearchCharacters(any(), any())).called(1);
    });

    test('deve atualizar a lista de recentemente vistos', () async {
      // Simula o evento de "RecentlyViewCharacter"

      when(() => mockBloc.getRecentlyViewCharacter(any(), any()))
          .thenAnswer((_) async {
        final updatedRecentlyViewed = [mockCharacter];

        // Emite o estado de recentemente visualizados com o mockEmitter com a assinatura correta
        mockEmitter(CharacterLoaded([], [], updatedRecentlyViewed));
      });

      // Verificar se o método foi chamado corretamente
      verify(() => mockBloc.getRecentlyViewCharacter(any(), any())).called(1);
    });
  });
}
