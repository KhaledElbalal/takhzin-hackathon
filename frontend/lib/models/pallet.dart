
class Pallet {
  final int id;
  final String? productInstance;
  final bool reserved;
  final String? reservedCustomer;
  final String? supplier;
  final String? warehouseObject;

  Pallet({
    required this.id,
    this.productInstance,
    required this.reserved,
    this.reservedCustomer,
    this.supplier,
    this.warehouseObject,
  });

  factory Pallet.fromJson(Map<String, dynamic> json) => Pallet(
    id: json['id'] as int,
    productInstance: json['product_instance'] as String?,
    reserved: json['reserved'] as bool,
    reservedCustomer: json['reserved_customer'] as String?,
    supplier: json['supplier'] as String?,
    warehouseObject: json['warehouse_object'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'product_instance': productInstance,
    'reserved': reserved,
    'reserved_customer': reservedCustomer,
    'supplier': supplier,
    'warehouse_object': warehouseObject,
  };
}
