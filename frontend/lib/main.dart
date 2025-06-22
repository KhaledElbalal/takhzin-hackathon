import 'package:flutter/material.dart';
import 'models/warehouse.dart';
import 'models/product.dart';
import 'services/api_service.dart';
import 'screens/warehouse_edit.dart';
import 'screens/warehouse_view_page.dart';
import 'screens/dispatch_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warehouses',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    warehousesFuture = apiService.getWarehouses();
    productsFuture = apiService.getProducts();
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
            return ListView(
              children: [
                ...warehouses.map(
                  (warehouse) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ListTile(
                      title: Text(
                        warehouse.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('Size: ${warehouse.width} x ${warehouse.length}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
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
                          ElevatedButton(
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
                    ),
                  ),
                ),
                const Divider(),
                FutureBuilder<List<Product>>(
                  future: productsFuture,
                  builder: (context, prodSnap) {
                    if (prodSnap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (prodSnap.hasError) {
                      return Center(child: Text('Error: ${prodSnap.error}'));
                    } else if (!prodSnap.hasData || prodSnap.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('No products'),
                      );
                    } else {
                      final products = prodSnap.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: products
                            .map(
                              (p) => Card(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                child: ListTile(
                                  title: Text(
                                    p.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text('SKU: ${p.sku}'),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DispatchPage(sku: p.sku),
                                        ),
                                      );
                                    },
                                    child: const Text('Dispatch'),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
