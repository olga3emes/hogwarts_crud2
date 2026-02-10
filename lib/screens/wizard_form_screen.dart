import 'package:flutter/material.dart';
import '../models/wizard.dart';
import '../models/house.dart';
import '../models/wand.dart';
import '../services/wizard_service.dart';
import '../services/house_service.dart';
import '../services/wand_service.dart';

class WizardFormScreen extends StatefulWidget {
  final Wizard? wizard;
  final VoidCallback onSaved;

  const WizardFormScreen({super.key, this.wizard, required this.onSaved});

  @override
  State<WizardFormScreen> createState() => _WizardFormScreenState();
}

class _WizardFormScreenState extends State<WizardFormScreen> {
// Controladores para los campos de texto
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  // Servicios para manejar datos de magos, casas y varitas
 
  final formKey = GlobalKey<FormState>();
 
  final wizardService = WizardService();
  final houseService = HouseService();
  final wandService = WandService();

//Lista de casas y varitas para los dropdowns
  List<House> houses = [];
  List<Wand> wands = [];

//Variables para guardar la selección actual de los dropdowns
  String? selectedHouseId;
  String? selectedWandId;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    houses = await houseService.getHouses();
    wands = await wandService.getWands();

    if (widget.wizard != null) {
      final w = widget.wizard!;
      nameCtrl.text = w.name;
      ageCtrl.text = w.age.toString();
      selectedHouseId = w.houseId;
      selectedWandId = w.wandId;
    }

    if (mounted) setState(() {});
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
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(isEdit ? "Editar Mago" : "Nuevo Mago")),

      // ------------------------------
      // Botón FIJO abajo
      // ------------------------------
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final name = nameCtrl.text;
              final age = int.parse(ageCtrl.text);

              if (isEdit) {
                await wizardService.updateWizard(
                  widget.wizard!.id,
                  name,
                  age,
                  selectedHouseId,
                  selectedWandId,
                );
              } else {
                await wizardService.addWizard(
                  name,
                  age,
                  selectedHouseId ?? "",
                  selectedWandId ?? "",
                );
              }

              if (!mounted) return;
              widget.onSaved();
              Navigator.of(context).pop();
            },
            child: Text(isEdit ? "Guardar cambios" : "Crear mago"),
          ),
        ),
      ),

      // ------------------------------
      // FORMULARIO SCROLLEABLE
      // ------------------------------
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco limpio
            ),

            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, 

                children: [
                  // Nombre
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? "Obligatorio" : null,
                  ),

                  const SizedBox(height: 20),

                  // Edad
                  TextFormField(
                    controller: ageCtrl,
                    decoration: const InputDecoration(
                      labelText: "Edad",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Obligatorio";
                      final n = int.tryParse(v);
                      return (n == null || n <= 0) ? "Edad inválida" : null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // CASA — sin expanded y a ancho completo
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
                          .map((h) =>
                              DropdownMenuEntry<String>(value: h.id, label: h.name))
                          .toList(),

                      onSelected: (value) =>
                          setState(() => selectedHouseId = value),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // VARITA — igual estilo
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
                              label: "${w.wood} - ${w.core}",
                            ),
                          )
                          .toList(),

                      onSelected: (value) =>
                          setState(() => selectedWandId = value),
                    ),
                  ),

                  const SizedBox(height: 80), // deja hueco para el botón fijo
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
