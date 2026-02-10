import 'package:flutter/material.dart';
import '../models/house.dart';
import '../services/house_service.dart';
import 'house_list_screen.dart';

class HouseFormScreen extends StatefulWidget {
  final House? house; // Si viene con casa, es edición
  final VoidCallback onSaved;

  const HouseFormScreen({super.key, this.house, required this.onSaved});

  @override
  State<HouseFormScreen> createState() => _HouseFormScreenState();
}

class _HouseFormScreenState extends State<HouseFormScreen> {
  final nameCtrl = TextEditingController();
  final founderCtrl = TextEditingController();
  final service = HouseService();

  @override
  void initState() {
    super.initState();

    // Si estamos editando, rellenar campos
    if (widget.house != null) {
      nameCtrl.text = widget.house!.name;
      founderCtrl.text = widget.house!.founder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.house != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Editar Casa" : "Nueva Casa")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nombre de la casa"),
            ),
            TextField(
              controller: founderCtrl,
              decoration: const InputDecoration(labelText: "Fundador"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              child: Text(isEdit ? "Guardar cambios" : "Crear"),
              onPressed: () async {
                final name = nameCtrl.text;
                final founder = founderCtrl.text;

                if (isEdit) {
                  await service.updateHouse(widget.house!.id, name, founder);
                } else {
                  await service.addHouse(name, founder);
                }

                widget.onSaved();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}