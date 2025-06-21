class WarehouseObject {
  final String id;
  final String warehouse;
  final String objectType;
  final int width;
  final int length;
  final int x;
  final int y;

  WarehouseObject({
    required this.id,
    required this.warehouse,
    required this.objectType,
    required this.width,
    required this.length,
    required this.x,
    required this.y,
  });

  factory WarehouseObject.fromJson(Map<String, dynamic> json) => WarehouseObject(
        id: json['id'] as String,
        warehouse: json['warehouse'] as String,
        objectType: json['object_type'] as String,
        width: json['width'] as int,
        length: json['length'] as int,
        x: json['x'] as int,
        y: json['y'] as int,
      );

  Map<String, dynamic> toJson() => {
        'warehouse': warehouse,
        'object_type': objectType,
        'width': width,
        'length': length,
        'x': x,
        'y': y,
      };
}