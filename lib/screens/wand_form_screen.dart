import 'package:flutter/material.dart';
import '../services/wand_service.dart';
import '../models/wand.dart';
import 'wand_form_screen.dart';

class WandFormScreen extends StatefulWidget {
  final Wand? wand; // Si es null, es para crear. Si no, para editar.
  final VoidCallback
  onSave; // Callback para refrescar la lista después de guardar.

  const WandFormScreen({super.key, this.wand, required this.onSave});

  @override
  State<WandFormScreen> createState() => _WandFormScreenState();
}

class _WandFormScreenState extends State<WandFormScreen> {
  final service = WandService();
  final coreCtrl = TextEditingController(); // Controlador para el campo "core"
  final woodCtrl = TextEditingController(); // Controlador para el campo "wood"
  final lengthCtrl =
      TextEditingController(); // Controlador para el campo "length"

  @override
  void initState() {
    super.initState();
    if (widget.wand != null) {
      coreCtrl.text = widget.wand!.core;
      woodCtrl.text = widget.wand!.wood;
      lengthCtrl.text = widget.wand!.length.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.wand != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Varita' : 'Agregar Varita')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: coreCtrl,
              decoration: const InputDecoration(labelText: 'Núcleo'),
            ),
            TextField(
              controller: woodCtrl,
              decoration: const InputDecoration(labelText: 'Madera'),
            ),
            TextField(
              controller: lengthCtrl,
              decoration: const InputDecoration(labelText: 'Longitud (cm)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
           ElevatedButton(
             child: Text( isEdit ? 'Guardar Cambios' : 'Agregar Varita'),
              onPressed: () async {
                final core = coreCtrl.text;
                final wood = woodCtrl.text;
                final length = int.tryParse(lengthCtrl.text) ?? 0; // advertir si no es un número válido
  
                if (isEdit) {
                  await service.updateWand(widget.wand!.id, core, wood, length);
                } else {
                  await service.addWand(core, wood, length);
                }
                widget.onSave(); // Refrescar la lista
                Navigator.pop(context); // Volver a la pantalla anterior
              }),
          ],
        ),
      ),
    );
  }
}
