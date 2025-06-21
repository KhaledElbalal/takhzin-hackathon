import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model class for WarehouseObject
class WarehouseObject {
  final int id;
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

  factory WarehouseObject.fromJson(Map<String, dynamic> json) =>
      WarehouseObject(
        id: json['id'] as int,
        warehouse: json['warehouse'] as String,
        objectType: json['object_type'] as String,
        width: json['width'] as int,
        length: json['length'] as int,
        x: json['x'] as int,
        y: json['y'] as int,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'warehouse': warehouse,
      'object_type': objectType,
      'width': width,
      'length': length,
      'x': x,
      'y': y,
    };
  }
}

// API service class
class ApiService {
  final String baseUrl =
      'https://your-api-url.com'; // <-- change to your API base URL

  Future<List<WarehouseObject>> getWarehouseObjectsForWarehouse(
    String warehouseId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/warehouse-objects/?warehouse=$warehouseId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => WarehouseObject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load warehouse objects');
    }
  }
}

class WarehouseStatisticsPage extends StatefulWidget {
  @override
  _WarehouseStatisticsPageState createState() =>
      _WarehouseStatisticsPageState();
}

class _WarehouseStatisticsPageState extends State<WarehouseStatisticsPage> {
  late Future<List<WarehouseObject>> _futureWarehouseObjects;
  final ApiService _service = ApiService();
  final String warehouseId =
      'your_warehouse_id_here'; // Set your actual warehouse ID

  static const Color takhzinPrimary = Color(0xFFCF1D51);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color contentBackground = Color(0xFFF3F4F6); // light gray

  @override
  void initState() {
    super.initState();
    _futureWarehouseObjects = _service.getWarehouseObjectsForWarehouse(
      warehouseId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: takhzinPrimary,
        centerTitle: true,
        title: Text(
          'Warehouse Statistics',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<WarehouseObject>>(
        future: _futureWarehouseObjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: takhzinPrimary),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No warehouse objects found.',
                style: TextStyle(
                  color: textPrimary.withOpacity(0.7),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else {
            final objects = snapshot.data!;
            final usedCount = objects
                .where((o) => o.objectType == 'used_pallet')
                .length;
            final emptyCount = objects
                .where((o) => o.objectType == 'empty_pallet')
                .length;

            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: contentBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Used pallets indicator
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Text(
                          'Used Pallets: $usedCount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 40),
                    // Empty pallets indicator
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Text(
                          'Empty Pallets: $emptyCount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
