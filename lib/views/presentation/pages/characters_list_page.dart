import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc_events.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc_state.dart';
import 'package:marvel_app/views/presentation/pages/characters_details_page.dart';
import 'package:marvel_app/views/presentation/widgets/characters_card_widget.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: SizedBox(
          width: 98,
          height: 39,
          child: Image.asset(
            'assets/Marvel_Logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<CharacterBloc, CharacterState>(
                    builder: (context, state) {
                  if (state is CharacterLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CharacterLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.recentlyViewed.isNotEmpty) ...[
                          Text(
                            'FEATURED CHARACTERS',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                            ),
                            itemCount: state.recentlyViewed.length > 2
                                ? 2
                                : state.recentlyViewed.length,
                            itemBuilder: (context, index) {
                              final character = state.recentlyViewed[index];
                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<CharacterBloc>()
                                      .add(RecentlyViewCharacter(character));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CharacterDetailPage(
                                          character: character),
                                    ),
                                  );
                                },
                                child: CharacterCard(
                                  name: character.name,
                                  thumbnail: character.thumbnail,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                        Text(
                          'MARVEL CHARACTERS LIST',
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.roboto(fontSize: 15),
                            hintText: 'Search characters',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onChanged: (query) {
                            context
                                .read<CharacterBloc>()
                                .add(SearchCharacters(query));
                          },
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                          ),
                          itemCount: state.filteredCharacters.length,
                          itemBuilder: (context, index) {
                            final character = state.filteredCharacters[index];
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<CharacterBloc>()
                                    .add(RecentlyViewCharacter(character));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CharacterDetailPage(
                                        character: character),
                                  ),
                                );
                              },
                              child: CharacterCard(
                                name: character.name,
                                thumbnail: character.thumbnail,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else if (state is CharacterError) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 215),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 150,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              state.message,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
