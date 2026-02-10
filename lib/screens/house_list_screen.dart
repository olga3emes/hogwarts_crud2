import 'package:flutter/material.dart';
import '../services/house_service.dart';
import '../models/house.dart';
import 'house_form_screen.dart';

class HouseListScreen extends StatefulWidget {
  const HouseListScreen({super.key});

  @override
  State<HouseListScreen> createState() => _HouseListScreenState();
}

class _HouseListScreenState extends State<HouseListScreen> {
  final service = HouseService();
  late Future<List<House>> futureHouses;

  @override
  void initState() {
    super.initState();
    // Cargamos la lista al iniciar
    futureHouses = service.getHouses();
  }

  // Recargar lista después de agregar/editar/eliminar
  void _refresh() {
    setState(() {
      futureHouses = service.getHouses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Casas")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          //Aquí hay que enviarle un House h nulo para que sepa que es nuevo.
          MaterialPageRoute(
            builder: (_) => HouseFormScreen(house: null, onSaved: _refresh),
          ),
        ),
      ),
      body: FutureBuilder(
        future: futureHouses,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final houses = snapshot.data!;

          return ListView.builder(
            itemCount: houses.length,
            itemBuilder: (context, i) {
              final h = houses[i];

              return ListTile(
                contentPadding: const EdgeInsets.all(12.0),
                leading: const Icon(Icons.castle, size: 20),
                title: Text(
                  h.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Fundador: ${h.founder}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                // Botón eliminar
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await service.deleteHouse(h.id);
                    _refresh();

                  },
                ),

                // Tap para editar
                onTap: () => Navigator.push(
                  context,
                  //Para enviar datos a otra pantalla, hay que meterle luego House h.
                  MaterialPageRoute(
                    builder: (_) =>
                        HouseFormScreen(house: h, onSaved: _refresh),
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
