import 'package:flutter/material.dart';
import 'package:hogwarts_crud2/supabase_config.dart';
import 'package:hogwarts_crud2/screens/home_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseConfig.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hogwarts CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
      
  }
}
