class Product {
  final String id;
  final String sku;
  final String name;
  final String description;
  final int maxBoxesPerPallet;
  final DateTime expiryDate;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.maxBoxesPerPallet,
    required this.expiryDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        sku: json['sku'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        maxBoxesPerPallet: json['max_boxes_per_pallet'] as int,
        expiryDate: DateTime.parse(json['expiry_date'] as String),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'max_boxes_per_pallet': maxBoxesPerPallet,
        'expiry_date': expiryDate.toIso8601String().split('T').first,
      };
}