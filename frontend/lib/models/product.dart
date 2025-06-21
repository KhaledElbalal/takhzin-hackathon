class Product {
  final String id;
  final String sku;
  final String name;
  final String description;
  final int maxBoxesPerPallet;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.maxBoxesPerPallet,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        sku: json['sku'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        maxBoxesPerPallet: json['max_boxes_per_pallet'] as int,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'max_boxes_per_pallet': maxBoxesPerPallet,
      };
}