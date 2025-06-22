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
  final TextEditingController skuController = TextEditingController();
  final TextEditingController boxesController = TextEditingController();
  List<int> availablePallets = [];
  List<int> selectedPallets = [];
  String validationText = '';

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
            final warehouse = snapshot.data!;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: WarehouseView(
                      warehouse: warehouse,
                      allowEdit: false,
                    ),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: skuController,
                          decoration: const InputDecoration(labelText: 'SKU'),
                        ),
                        TextField(
                          controller: boxesController,
                          decoration: const InputDecoration(labelText: 'Boxes'),
                          keyboardType: TextInputType.number,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final sku = skuController.text;
                                final boxes = int.tryParse(boxesController.text) ?? 0;
                                try {
                                  final res = await apiService.validateWarehouseSpace(
                                      warehouse.id, sku, boxes);
                                  setState(() {
                                    availablePallets =
                                        List<int>.from(res['empty_pallets'] ?? []);
                                    selectedPallets = [];
                                    validationText = availablePallets.join(', ');
                                  });
                                  if (availablePallets.length <
                                      (res['pallets_needed'] ?? 0)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Not enough empty pallets')));
                                  }
                                } catch (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Error')));
                                }
                              },
                              child: const Text('Validate'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: selectedPallets.isEmpty
                                  ? null
                                  : () async {
                                      final boxes =
                                          int.tryParse(boxesController.text) ?? 0;
                                      try {
                                        await apiService.reserveWarehousePallets(
                                            warehouse.id,
                                            skuController.text,
                                            boxes,
                                            selectedPallets);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content: Text('Pallets reserved')));
                                      } catch (_) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content: Text('Reserve failed')));
                                      }
                                    },
                              child: const Text('Reserve'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Available: $validationText'),
                        Expanded(
                          child: ListView(
                            children: availablePallets
                                .map(
                                  (id) => CheckboxListTile(
                                    title: Text('Pallet $id'),
                                    value: selectedPallets.contains(id),
                                    onChanged: (v) {
                                      setState(() {
                                        if (v == true) {
                                          selectedPallets.add(id);
                                        } else {
                                          selectedPallets.remove(id);
                                        }
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
