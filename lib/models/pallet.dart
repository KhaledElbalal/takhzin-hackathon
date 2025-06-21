class Pallet {
  final String id;
  final String status;
  final bool reserved;
  final String? reservedCustomer;
  final String? supplier;

  Pallet({
    required this.id,
    required this.status,
    required this.reserved,
    this.reservedCustomer,
    this.supplier,
  });

  factory Pallet.fromJson(Map<String, dynamic> json) => Pallet(
        id: json['id'] as String,
        status: json['status'] as String,
        reserved: json['reserved'] as bool,
        reservedCustomer: json['reserved_customer'] as String?,
        supplier: json['supplier'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'reserved': reserved,
        'reserved_customer': reservedCustomer,
        'supplier': supplier,
      };
}