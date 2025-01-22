import 'package:flutter/material.dart';
import 'package:marvel_app/presentation/pages/initial_page.dart';

void main() {
  runApp(const MarvelApp());
}

class MarvelApp extends StatelessWidget {
  const MarvelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const InitialPage();
  }
}
