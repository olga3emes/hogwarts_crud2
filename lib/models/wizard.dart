class Wizard {
  final String id;
  final String name;
  final String age;
  final String? houseId;
  final String? wandId;

  //Campos con el join (opcionales)
  final String? houseName;
  final String? wandWood;
  final String? wandCore;

Wizard({
    required this.id,
    required this.name,
    required this.age,
    this.houseId,
    this.wandId,
    this.houseName,
    this.wandWood,
    this.wandCore,
  });

  factory Wizard.fromMap(Map<String, dynamic> json) {
    return Wizard(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as String,
      houseId: json['house_id'],
      wandId: json['wand_id'],
      houseName: json['houses'] != null ? json['houses']['name']: null,
      wandWood: json['wands'] != null ? json['wands']['wood'] : null,
      wandCore: json['wands'] != null ? json['wands']['core'] : null,
    );
  }

}