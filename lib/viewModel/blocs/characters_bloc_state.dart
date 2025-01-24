import 'package:marvel_app/viewModel/models/characters_model.dart';

abstract class CharacterState {}

class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<CharacterModel> allCharacters;
  final List<CharacterModel> filteredCharacters;
  final List<CharacterModel> recentlyViewed;

  CharacterLoaded(
      this.allCharacters, this.filteredCharacters, this.recentlyViewed);
}

class CharacterError extends CharacterState {
  final String message;
  CharacterError(this.message);
}
