class House {
  final String id;
  final String name;
  final String founder;

  House({required this.id, required this.name, required this.founder});

  factory House.fromMap(Map<String, dynamic> json) {
    return House(
      id: json['id'] as String,
      name: json['name'] as String,
      founder: json['founder'] as String,
    );
  }
}
