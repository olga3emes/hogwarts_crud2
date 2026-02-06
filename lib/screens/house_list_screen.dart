import 'package:flutter/material.dart';

class HouseListScreen extends StatelessWidget {

  const HouseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Casas'),
      ),
      body: const Center(
        child: Text('Aquí se mostrarán las casas...'),
      ),
    );
  }


}