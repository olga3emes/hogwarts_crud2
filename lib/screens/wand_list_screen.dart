import 'package:flutter/material.dart';

class WandListScreen extends StatelessWidget {

  const WandListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Varitas'),
      ),
      body: const Center(
        child: Text('Aquí se mostrarán las varitas...'),
      ),
    );
  }


}