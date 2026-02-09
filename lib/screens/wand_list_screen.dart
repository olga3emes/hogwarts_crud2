import 'package:flutter/material.dart';
import '../services/wand_service.dart';
import '../models/wand.dart';
import 'wand_form_screen.dart';

class WandListScreen extends StatefulWidget {
  const WandListScreen({super.key});

  @override
  State<WandListScreen> createState() => _WandListScreenState();
}

class _WandListScreenState extends State<WandListScreen> {
  final service = WandService();
  late Future<List<Wand>> futureWands;

@override
  void initState() {
    super.initState();
    futureWands = service.getWands();
  }

  void _refresh() {
    setState(() {
      futureWands = service.getWands();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Varitas')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => WandFormScreen(onSave: _refresh)),
        ),
      ),

      body: FutureBuilder(
        future: futureWands,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final wands = snapshot.data!;

          return ListView.builder(
            itemCount: wands.length,
            itemBuilder: (context, index) {
              final wand = wands[index];
              return ListTile(
                title: Text('${wand.wood} con núcleo de ${wand.core}'),
                subtitle: Text('Longitud: ${wand.length} cm'),

                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await service.deleteWand(wand.id);
                    _refresh();
                  },
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WandFormScreen (wand: wand, onSave: _refresh)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
