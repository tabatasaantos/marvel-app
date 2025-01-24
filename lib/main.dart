import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc_events.dart';
import 'package:marvel_app/views/presentation/pages/initial_page.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => CharacterBloc()..add(GetAllCharacters()),
      ),
    ],
    child: const MarvelApp(),
  ));
}

class MarvelApp extends StatelessWidget {
  const MarvelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitialPage(),
    );
  }
}
