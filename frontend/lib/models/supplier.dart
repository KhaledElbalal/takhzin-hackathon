class Supplier {
  final String id;
  final String name;
  final List<String> pallets;

  Supplier({
    required this.id,
    required this.name,
    required this.pallets,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        id: json['id'] as String,
        name: json['name'] as String,
        pallets: List<String>.from(json['pallets'] as List),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}