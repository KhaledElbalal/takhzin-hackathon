class ProductInstance {
  final String id;
  final String product;
  final DateTime? productionDate;
  final String? batchNumber;
  final DateTime? expiryDate;

  ProductInstance({
    required this.id,
    required this.product,
    this.productionDate,
    this.batchNumber,
    this.expiryDate,
  });

  factory ProductInstance.fromJson(Map<String, dynamic> json) => ProductInstance(
        id: json['id'] as String,
        product: json['product'] as String,
        productionDate: json['production_date'] != null
            ? DateTime.parse(json['production_date'] as String)
            : null,
        batchNumber: json['batch_number'] as String?,
        expiryDate: json['expiry_date'] != null
            ? DateTime.parse(json['expiry_date'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'product': product,
        'production_date': productionDate?.toIso8601String().split('T').first,
        'batch_number': batchNumber,
        'expiry_date': expiryDate?.toIso8601String().split('T').first,
      };
}