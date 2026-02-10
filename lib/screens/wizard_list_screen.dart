import 'package:flutter/material.dart';
import '../services/wizard_service.dart';
import '../models/wizard.dart';
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

  /// Diálogo de confirmación antes de eliminar
  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("¿Eliminar mago?"),
            content: const Text("Esta acción no se puede deshacer."),
            actions: [
              TextButton(
                child: const Text("Cancelar"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text(
                  "Eliminar",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Magos"),
        centerTitle: true,
      ),

      // Botón flotante para crear mago
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WizardFormScreen(onSaved: _refresh),
            ),
          );
        },
      ),

      body: FutureBuilder(
        future: futureWizards,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final wizards = snapshot.data!;

          if (wizards.isEmpty) {
            return const Center(
              child: Text(
                "No hay magos registrados.\nPulsa el botón + para añadir uno.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: wizards.length,
            itemBuilder: (context, i) {
              final w = wizards[i];

              // Si no tiene casa o varita → S/N
              final casa = w.houseName ?? "S/N";
              final varita = (w.wandWood != null && w.wandCore != null)
                  ? "${w.wandWood} - ${w.wandCore}"
                  : "S/N";

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

                  leading: const Icon(Icons.person, size: 40, color: Colors.deepPurple),

                  title: Text(
                    w.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Edad: ${w.age}"),
                      Text("Casa: $casa"),
                      Text("Varita: $varita"),
                    ],
                  ),

                  // Iconos de editar y eliminar
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- ICONO EDITAR ---
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        tooltip: "Editar Mago",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WizardFormScreen(
                                wizard: w,
                                onSaved: _refresh,
                              ),
                            ),
                          );
                        },
                      ),

                      // --- ICONO ELIMINAR ---
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: "Eliminar Mago",
                        onPressed: () async {
                          final confirm = await _confirmDelete(context);
                          if (confirm) {
                            await service.deleteWizard(w.id);
                            _refresh();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}