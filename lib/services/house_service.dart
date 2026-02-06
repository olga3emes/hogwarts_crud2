import '../supabase_config.dart';
import '../models/house.dart';

class HouseService {
  //llamar a bbdd

  final _db = SupabaseConfig.client;

  //Voy a crear una lista de casas, no las tengo aún.
  // Hay que esperar a el servidor nos responda en el futuro.
  // Quiero que me una lista de casas -> Future<List<House>>
  //Esto es asíncrono, así que async
  //Tengo que esperar a que el servidor me responda, así que await

  Future<List<House>> getHouses() async {
    final response = await _db.from('houses').select();

    //transformar la respuesta a objeto House
    return response.map((e) => House.fromMap(e)).toList();
  }

  Future<void> addHouse(String name, String founder) async {
    await _db.from('houses').insert({'name': name, 'founder': founder});
  }

  // Editar

  Future<void> updateHouse(String id, String name, String founder) async {
    await _db
        .from('houses')
        .update({'name': name, 'founder': founder})
        .eq('id', id);
  }

  //Eliminar

  Future<void> deleteHouse(String id) async {
    await _db.from('wizards').delete().eq('id', id);
  }
}
