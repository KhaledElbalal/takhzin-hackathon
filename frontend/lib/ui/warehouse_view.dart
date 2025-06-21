import 'package:flutter/material.dart';
import '../models/warehouse.dart';
import '../models/warehouse_object.dart';
import '../services/api_service.dart';

class WarehouseView extends StatefulWidget {
  final Warehouse warehouse;

  const WarehouseView({required this.warehouse, Key? key}) : super(key: key);

  @override
  State<WarehouseView> createState() => _WarehouseViewState();
}

class _WarehouseViewState extends State<WarehouseView> {
  final double canvasSize = 1200;
  final ApiService apiService = ApiService();
  String selectedType = 'Pallet';
  final List<String> objectTypes = ['Pallet', 'Obstacle'];

  void _showAddDialog(int tappedX, int tappedY) {
    final widthController = TextEditingController();
    final lengthController = TextEditingController();
    final selectedTypeController = TextEditingController(text: selectedType);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Object'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Position: ($tappedX, $tappedY)'),
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
                    });
                  }
                },
              ),
              TextField(
                controller: widthController,
                decoration: InputDecoration(labelText: 'Width'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lengthController,
                decoration: InputDecoration(labelText: 'Length'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                int width = int.tryParse(widthController.text) ?? 1;
                int length = int.tryParse(lengthController.text) ?? 1;
                String selectedType = this.selectedType;

                final newObj = WarehouseObject(
                  id: 0,
                  warehouse: widget.warehouse.id,
                  objectType: selectedType,
                  width: width,
                  length: length,
                  x: tappedX,
                  y: tappedY,
                );

                final createdObj = await apiService.createWarehouseObject(newObj);

                setState(() {
                  widget.warehouse.warehouseObjects.add(createdObj);
                });

                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double scaleX = canvasSize / widget.warehouse.width;
    double scaleY = canvasSize / widget.warehouse.length;

    return GestureDetector(
      onTapDown: (details) {
        int tappedX = (details.localPosition.dx / scaleX).floor();
        int tappedY = ((canvasSize - details.localPosition.dy) / scaleY).floor();
        _showAddDialog(tappedX, tappedY);
      },
      child: Container(
        width: canvasSize,
        height: canvasSize,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Stack(
          children: widget.warehouse.warehouseObjects.map((obj) {
            return Positioned(
              left: obj.x * scaleX,
              top: canvasSize - (obj.y + obj.length) * scaleY,
              width: obj.width * scaleX,
              height: obj.length * scaleY,
              child: Container(
                color: obj.objectType == 'Pallet' ? Colors.green : Colors.black,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}