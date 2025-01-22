import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 400),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/Marvel_Logo.png',
                  width: 98,
                  height: 39,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
