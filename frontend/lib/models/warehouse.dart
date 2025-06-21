import 'warehouse_object.dart';

class Warehouse {
  final String id;
  final String name;
  final int width;
  final int length;
  final List<WarehouseObject> objects;

  Warehouse({
    required this.id,
    required this.name,
    required this.width,
    required this.length,
    required this.objects,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        id: json['id'] as String,
        name: json['name'] as String,
        width: json['width'] as int,
        length: json['length'] as int,
        objects: (json['objects'] as List)
            .map((e) => WarehouseObject.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'width': width,
        'length': length,
      };
}