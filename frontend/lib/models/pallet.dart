class Pallet {
  final String id;
  final String productInstance;
  final bool reserved;
  final String? reservedCustomer;
  final String? supplier;

  Pallet({
    required this.id,
    required this.productInstance,
    required this.reserved,
    this.reservedCustomer,
    this.supplier,
  });

  factory Pallet.fromJson(Map<String, dynamic> json) => Pallet(
        id: json['id'] as String,
        productInstance: json['product_instance'] as String,
        reserved: json['reserved'] as bool,
        reservedCustomer: json['reserved_customer'] as String?,
        supplier: json['supplier'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'product_instance': productInstance,
        'reserved': reserved,
        'reserved_customer': reservedCustomer,
        'supplier': supplier,
      };
}