import 'package:flutter/material.dart';
import '../models/warehouse.dart';
import '../models/warehouse_object.dart';
import '../services/api_service.dart';

class WarehouseView extends StatefulWidget {
  final Warehouse warehouse;
  final bool allowEdit;

  const WarehouseView({required this.warehouse, this.allowEdit = false, Key? key})
      : super(key: key);

  @override
  State<WarehouseView> createState() => _WarehouseViewState();
}

class _WarehouseViewState extends State<WarehouseView> {
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
                String selectedType = this.selectedType.toLowerCase();

                final newObj = WarehouseObject(
                  id: '',
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
    double availableWidth = MediaQuery.of(context).size.width - 260;
    if (availableWidth < 300) availableWidth = 300;
    double scale = availableWidth / widget.warehouse.width;
    double canvasWidth = availableWidth;
    double canvasHeight = widget.warehouse.length * scale;
    double scaleX = scale;
    double scaleY = scale;

    return GestureDetector(
      onTapDown: (details) {
        if (widget.allowEdit) {
          int tappedX = (details.localPosition.dx / scaleX).floor();
          int tappedY =
              ((canvasHeight - details.localPosition.dy) / scaleY).floor();
          _showAddDialog(tappedX, tappedY);
        }
      },
      child: Container(
        width: canvasWidth,
        height: canvasHeight,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Stack(
          children: widget.warehouse.warehouseObjects.map((obj) {
            Color color;
            switch (obj.objectType.toLowerCase()) {
              case 'pallet':
                color = Colors.green;
                break;
              case 'road':
                color = Colors.brown;
                break;
              default:
                color = Colors.grey.shade800;
            }

            return Positioned(
              left: obj.x * scaleX,
              top: canvasHeight - (obj.y + obj.length) * scaleY,
              width: (obj.width * scaleX).clamp(10, double.infinity),
              height: (obj.length * scaleY).clamp(10, double.infinity),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Object Details'),
                      content: Text(
                          'Type: ${obj.objectType}\nSize: ${obj.width}x${obj.length}\nPosition: (${obj.x}, ${obj.y})'),
                    ),
                  );
                },
                child: Tooltip(
                  message:
                      'Type: ${obj.objectType}\n${obj.width}x${obj.length} at (${obj.x}, ${obj.y})',
                  child: Container(color: color),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}