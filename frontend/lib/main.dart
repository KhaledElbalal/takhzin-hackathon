import 'package:flutter/material.dart';
import 'models/warehouse.dart';
import 'services/api_service.dart';
import 'screens/warehouse_edit.dart';
import 'screens/warehouse_view_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warehouses',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WarehouseListScreen(),
    );
  }
}

class WarehouseListScreen extends StatefulWidget {
  const WarehouseListScreen({super.key});

  @override
  State<WarehouseListScreen> createState() => _WarehouseListScreenState();
}

class _WarehouseListScreenState extends State<WarehouseListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Warehouse>> warehousesFuture;

  @override
  void initState() {
    super.initState();
    warehousesFuture = apiService.getWarehouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Warehouses')),
      body: FutureBuilder<List<Warehouse>>(
        future: warehousesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No warehouses found'));
          } else {
            final warehouses = snapshot.data!;
            return ListView.builder(
              itemCount: warehouses.length,
              itemBuilder: (context, index) {
                final warehouse = warehouses[index];
                return ListTile(
                  title: Text(warehouse.name),
                  subtitle: Text('Size: ${warehouse.width} x ${warehouse.length}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WarehouseViewPage(warehouseId: warehouse.id),
                            ),
                          );
                        },
                        child: const Text('View'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WarehouseEditPage(warehouseId: warehouse.id),
                            ),
                          );
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
