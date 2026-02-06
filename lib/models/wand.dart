class Wand {
  final String id;
  final String wood;
  final String core;
  final int length;

  Wand({
    required this.id,
    required this.wood,
    required this.core,
    required this.length,
  });


  //Crear desde JSON de Supabase
  factory Wand.fromMap(Map<String, dynamic> json) {
    return Wand(
      id: json['id'] as String,
      wood: json['wood'] as String,
      core: json['core'] as String,
      length: json['length'] as int,
    );
  }

}
