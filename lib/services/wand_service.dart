import '../supabase_config.dart';
import '../models/wand.dart';

class WandService {
  final _db = SupabaseConfig.client;

  // Obtener todas las varitas
  Future<List<Wand>> getWands() async {
    final response = await _db.from('wands').select();
    return response.map((e) => Wand.fromMap(e)).toList();// Hay que paginar o hacer una carga dinámica
  }

  // Crear varita
  Future<void> addWand(String core, String wood, int length) async {
    await _db.from('wands').insert({
      'core': core,
      'wood': wood,
      'length': length,
    });
  }

  // Editar varita
  Future<void> updateWand(String id, String core, String wood, int length) async {
    await _db.from('wands').update({
      'core': core,
      'wood': wood,
      'length': length, 
    }).eq('id', id);
  }

  // Eliminar varita
  Future<void> deleteWand(String id) async {
    await _db.from('wands').delete().eq('id', id);
  }
}