// main.dart
import 'package:flutter/material.dart';
import 'package:hackathon/services/api_service.dart';
import 'package:hackathon/ui/warehouse_view.dart';
import 'models/warehouse.dart';
import 'models/warehouse_object.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warehouse Viewer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WarehouseScreen(),
    );
  }
}

class WarehouseScreen extends StatefulWidget {
  @override
  _WarehouseScreenState createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  final ApiService apiService = ApiService();
  late Future<Warehouse> warehouseFuture;
  late Warehouse warehouse;

  @override
  void initState() {
    super.initState();
    warehouseFuture = apiService.getWarehouse("32ef7f79-f154-43ba-8be1-7a1db92da430");
    warehouseFuture.then((value) {
      setState(() {
        warehouse = value;
      });
    });
  }
  void _addObject(int x, int y, int width, int length, String type) {
    final newObj = WarehouseObject(
      id: DateTime.now().toIso8601String(),
      warehouse: warehouse.id,
      objectType: type,
      width: width,
      length: length,
      x: x,
      y: y,
    );

    setState(() {
      warehouse.warehouseObjects.add(newObj);
    });
  }

  final _xController = TextEditingController();
  final _yController = TextEditingController();
  final _widthController = TextEditingController();
  final _lengthController = TextEditingController();
  final List<String> objectTypes = ['Obstacle', 'Pallet'];
  String selectedType = 'Obstacle';
  final _typeController = TextEditingController(text: 'Obstacle');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Warehouse')),
      body: FutureBuilder<Warehouse>(
        future: warehouseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
            warehouse = snapshot.data!; // Initialize the warehouse variable
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: WarehouseView(
                      warehouse: warehouse,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildField(_xController, 'X'),
                          _buildField(_yController, 'Y'),
                          _buildField(_widthController, 'Width'),
                          _buildField(_lengthController, 'Length'),
                          DropdownButton<String>(
                            value: selectedType,
                            items: objectTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedType = newValue;
                                  _typeController.text = newValue;
                                });
                              }
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              int x = int.tryParse(_xController.text) ?? 0;
                              int y = int.tryParse(_yController.text) ?? 0;
                              int w = int.tryParse(_widthController.text) ?? 1;
                              int l = int.tryParse(_lengthController.text) ?? 1;
                              String type = _typeController.text;
                              _addObject(x, y, w, l, type);
                            },
                            child: Text('Apply'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
