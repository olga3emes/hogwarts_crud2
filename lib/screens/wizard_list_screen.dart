import 'package:flutter/material.dart';
import '../models/wizard.dart';
import 'package:hogwarts_crud2/services/wizard_service.dart';
import 'wizard_form_screen.dart';

class WizardListScreen extends StatefulWidget {

  const WizardListScreen({super.key});

  @override
  State<WizardListScreen> createState() => _WizardListScreenState();

}

class _WizardListScreenState extends State<WizardListScreen> {
  final service = WizardService();
  late Future<List<Wizard>> futureWizards;


  @override
  void initState() {
    super.initState();
    futureWizards = service.getWizards();
  }

  void _refresh() {
    setState(() {
      futureWizards = service.getWizards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de magos")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
         Navigator.push(context, MaterialPageRoute(builder: (_) => WizardFormScreen(onSave: _refresh)));
        },
      ),// Botón para agregar nuevo mago
body: FutureBuilder(
        future: futureWizards,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final wizards = snapshot.data!;

          if (wizards.isEmpty) {
            return const Center(child: Text('No hay magos registrados'));
          }

          return ListView.builder(
            itemCount: wizards.length,
            itemBuilder: (context, index) {
              final w = wizards[index];
              return ListTile(
                title: Text(w.name),
                subtitle: Text('Casa: ${w.houseName ?? "S/N"} - Varita: ${w.wandWood ?? "S/N"} con núcleo de ${w.wandCore ?? "S/N"}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await service.deleteWizard(w.id);
                    _refresh();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}