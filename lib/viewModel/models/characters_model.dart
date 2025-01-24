class CharacterModel {
  final int id;
  final String name;
  final String thumbnail;
  final String description;

  CharacterModel({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      thumbnail:
          "${json['thumbnail']['path']}.${json['thumbnail']['extension']}",
      description: json['description'] ?? 'Descrição não disponível',
    );
  }
}
