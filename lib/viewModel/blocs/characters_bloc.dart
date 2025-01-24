import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:marvel_app/key.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc_events.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc_state.dart';
import 'package:marvel_app/viewModel/models/characters_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://gateway.marvel.com:443/v1/public/characters';

  List<CharacterModel> allCharacters = [];
  List<CharacterModel> recentlyViewed = [];

  CharacterBloc() : super(CharacterInitial()) {
    on<GetAllCharacters>(getAllCharacters);
    on<GetCharacterById>(getCharacterById);
    on<SearchCharacters>(getSearchCharacters);
    on<RecentlyViewCharacter>(getRecentlyViewCharacter);
  }

  Future<void> getAllCharacters(
      GetAllCharacters event, Emitter<CharacterState> emit) async {
    emit(CharacterLoading());

    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateMarvelHash(timestamp, privateKey, publicKey);

    final String url = '$_baseUrl?ts=$timestamp&apikey=$publicKey&hash=$hash';

    try {
      final response = await _dio.get(url);
      final data = response.data['data']['results'] as List;
      allCharacters = data.map((e) => CharacterModel.fromJson(e)).toList();
      emit(CharacterLoaded(allCharacters, allCharacters, recentlyViewed));
    } catch (e) {
      emit(CharacterError('Erro ao carregar lista de personagens'));
    }
  }

  Future<void> getCharacterById(
      GetCharacterById event, Emitter<CharacterState> emit) async {
    emit(CharacterLoading());

    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateMarvelHash(timestamp, privateKey, publicKey);

    final String url =
        '$_baseUrl/${event.id}?ts=$timestamp&apikey=$publicKey&hash=$hash';

    try {
      final response = await _dio.get(url);
      final data = response.data['data']['results'][0];
      final character = CharacterModel.fromJson(data);
      recentlyViewed.removeWhere((c) => c.id == character.id);
      recentlyViewed.insert(0, character);
      if (recentlyViewed.length > 2) {
        recentlyViewed.removeLast();
      }

      emit(CharacterLoaded(allCharacters, allCharacters, recentlyViewed));
    } catch (e) {
      emit(CharacterError('Erro ao carregar o personagem'));
    }
  }

  void getSearchCharacters(
      SearchCharacters event, Emitter<CharacterState> emit) {
    final filtered = allCharacters
        .where((character) =>
            character.name.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(CharacterLoaded(allCharacters, filtered, recentlyViewed));
  }

  void getRecentlyViewCharacter(
      RecentlyViewCharacter event, Emitter<CharacterState> emit) {
    recentlyViewed.removeWhere((c) => c.id == event.character.id);
    recentlyViewed.insert(0, event.character);
    if (recentlyViewed.length > 2) {
      recentlyViewed.removeLast();
    }
    emit(CharacterLoaded(allCharacters, allCharacters, recentlyViewed));
  }

  String generateMarvelHash(
      String timestamp, String privateKey, String publicKey) {
    final input = '$timestamp$privateKey$publicKey';
    return md5.convert(utf8.encode(input)).toString();
  }
}
