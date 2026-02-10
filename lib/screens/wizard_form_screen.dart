import 'package:flutter/material.dart';
import 'package:hogwarts_crud2/models/house.dart';
import 'package:hogwarts_crud2/services/wand_service.dart';
import '../models/wizard.dart';
import '../models/wand.dart';
import '../models/house.dart';
import '../services/wizard_service.dart';
import '../services/house_service.dart';
import '../services/wand_service.dart';

import 'wizard_list_screen.dart';

class WizardFormScreen extends StatefulWidget {
  final Wizard? wizard; // Si es null, es para crear. Si no, para editar.
  final VoidCallback
  onSave; // Callback para refrescar la lista después de guardar.

  const WizardFormScreen({super.key, this.wizard, required this.onSave});

  @override
  State<WizardFormScreen> createState() => _WizardFormScreenState();
}

class _WizardFormScreenState extends State<WizardFormScreen> {
  final service = WizardService();
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final houseCtrl = TextEditingController();
  final wandWoodCtrl = TextEditingController();
  final wandCoreCtrl = TextEditingController();

  final WandService wandService = WandService();
  final HouseService houseService = HouseService();
  List<House> houses = [];
  List<Wand> wands = [];

  // Vamos a cargar las casas y varitas para mostrarlas en los dropdowns
  String? selectedHouseId;
  String? selectedWandId;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final houses = await houseService.getHouses();
    final wands = await wandService.getWands();

    if (widget.wizard != null) {
      final w = widget.wizard!;
      nameCtrl.text = w.name;
      ageCtrl.text = w.age.toString();
      selectedHouseId = w.houseId;
      selectedWandId = w.wandId;
    }

    if(mounted) { // Verificamos que el widget sigue en pantalla antes de actualizar el estado
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.wizard != null;
    // Tema local para dar formato tipo TextField a los DropdownMenu
    final dropdownTheme = Theme.of(context).copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Mago' : 'Agregar Mago')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: ageCtrl,
              decoration: const InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),

            Theme(
              data: dropdownTheme,
              child: DropdownMenu<String>(
                initialSelection: selectedHouseId,
                label: const Text("Casa"),
                menuStyle: MenuStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
                ),

                dropdownMenuEntries: houses
                    .map(
                      (h) =>
                          DropdownMenuEntry<String>(value: h.id, label: h.name),
                    )
                    .toList(),

                onSelected: (value) => setState(() => selectedHouseId = value),
              ),
            ),
            const SizedBox(height: 20),

            //--------------------------------
            Theme(
              data: dropdownTheme,
              child: DropdownMenu<String>(
                initialSelection: selectedWandId,
                label: const Text("Varita"),
                menuStyle: MenuStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
                ),

                dropdownMenuEntries: wands
                    .map(
                      (w) => DropdownMenuEntry<String>(
                        value: w.id,
                        label: w.wood + " - " + w.core,
                      ),
                    )
                    .toList(),

                onSelected: (value) => setState(() => selectedWandId = value),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(isEdit ? 'Guardar Cambios' : 'Agregar Mago'),
              onPressed: () async {
                final name = nameCtrl.text;
                final age = int.tryParse(ageCtrl.text) ?? 0;
                if (isEdit) {
                  await service.updateWizard(
                    widget.wizard!.id,
                    name,
                    age,
                    selectedHouseId ?? "",
                    selectedWandId ?? "",
                  );
                } else {
                  await service.addWizard(
                    name,
                    age,
                    selectedHouseId ?? "",
                    selectedWandId ?? "",
                  );
                }
                widget.onSave(); // Refrescar la lista
                Navigator.pop(context); // Volver a la pantalla anterior
              },
            ),
          ],
        ),
      ),
    );
  }
}
