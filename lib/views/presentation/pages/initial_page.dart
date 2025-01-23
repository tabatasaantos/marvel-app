import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc.dart';
import 'package:marvel_app/viewModel/blocs/characters_bloc_state.dart';
import 'package:marvel_app/views/presentation/pages/characters_list_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
      return Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<CharacterBloc>(),
                  child: const CharacterListPage(),
                ),
              ),
            );
          },
          child: SizedBox(
            width: 98,
            height: 39,
            child: Image.asset(
              'assets/Marvel_Logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    });
  }
}
