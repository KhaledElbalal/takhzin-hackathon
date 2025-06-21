import 'package:flutter/material.dart';
import 'package:hackathon/services/api_service.dart';
import 'package:hackathon/ui/warehouse_view.dart';
import '../models/warehouse.dart';
import '../models/warehouse_object.dart';

class WarehouseEditPage extends StatefulWidget {
  final String warehouseId;

  const WarehouseEditPage({required this.warehouseId, Key? key}) : super(key: key);

  @override
  _WarehouseEditPageState createState() => _WarehouseEditPageState();
}

class _WarehouseEditPageState extends State<WarehouseEditPage> {
  final ApiService apiService = ApiService();
  late Future<Warehouse> warehouseFuture;
  late Warehouse warehouse;

  @override
  void initState() {
    super.initState();
    warehouseFuture = apiService.getWarehouse(widget.warehouseId);
    warehouseFuture.then((value) {
      setState(() {
        warehouse = value;
      });
    });
  }
  void _addObject(int x, int y, int width, int length, String type) {
    final newObj = WarehouseObject(
      id: '',
      warehouse: warehouse.id,
      objectType: type.toLowerCase(),
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
          } else if (snapshot.hasData) {
            warehouse = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: WarehouseView(
                      warehouse: warehouse,
                      allowEdit: true,
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
