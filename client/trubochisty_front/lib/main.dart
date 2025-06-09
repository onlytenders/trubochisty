import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/culvert_provider.dart';
import 'screens/culvert_management_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CulvertProvider(),
      child: MaterialApp(
        title: 'TruboHisty',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const CulvertManagementScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
