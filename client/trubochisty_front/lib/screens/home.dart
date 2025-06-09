import 'package:flutter/material.dart';
import '../widgets/PipeCard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: PipeCard()),
    );
  }
}