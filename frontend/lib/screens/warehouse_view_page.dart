import 'package:flutter/material.dart';
import 'package:hackathon/services/api_service.dart';
import 'package:hackathon/ui/warehouse_view.dart';
import '../models/warehouse.dart';
import 'warehouse_statistics_page.dart';

class WarehouseViewPage extends StatefulWidget {
  final String warehouseId;
  const WarehouseViewPage({required this.warehouseId, Key? key}) : super(key: key);

  @override
  State<WarehouseViewPage> createState() => _WarehouseViewPageState();
}

class _WarehouseViewPageState extends State<WarehouseViewPage> {
  final ApiService apiService = ApiService();
  late Future<Warehouse> warehouseFuture;

  @override
  void initState() {
    super.initState();
    warehouseFuture = apiService.getWarehouse(widget.warehouseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouse View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WarehouseStatisticsPage()),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<Warehouse>(
        future: warehouseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Center(
              child: WarehouseView(
                warehouse: snapshot.data!,
                allowEdit: false,
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
