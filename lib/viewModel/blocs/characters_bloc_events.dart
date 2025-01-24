import 'package:marvel_app/viewModel/models/characters_model.dart';

abstract class CharacterEvent {}

class GetAllCharacters extends CharacterEvent {}

class GetCharacterById extends CharacterEvent {
  final int id;
  GetCharacterById(this.id);
}

class SearchCharacters extends CharacterEvent {
  final String query;
  SearchCharacters(this.query);
}

class RecentlyViewCharacter extends CharacterEvent {
  final CharacterModel character;
  RecentlyViewCharacter(this.character);
}
