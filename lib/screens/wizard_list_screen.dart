import 'package:flutter/material.dart';

class WizardListScreen extends StatelessWidget {

  const WizardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Magos'),
      ),
      body: const Center(
        child: Text('Aquí se mostrarán los magos...'),
      ),
    );
  }


}