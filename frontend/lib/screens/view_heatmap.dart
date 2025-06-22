import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ViewHeatmapScreen extends StatefulWidget {
  const ViewHeatmapScreen({Key? key}) : super(key: key);

  @override
  State<ViewHeatmapScreen> createState() => _ViewHeatmapScreenState();
}

class _ViewHeatmapScreenState extends State<ViewHeatmapScreen> {
  bool _isLoading = true;
  Uint8List? _imageBytes;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchHeatmap();
  }

  Future<void> _fetchHeatmap() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await http.get(Uri.parse(
          'http://localhost:8000/api/warehouses/2bb66559-2dad-484f-96d7-1074ede411b7/heatmap/'));

      if (response.statusCode == 200) {
        // Since content-type is image/png, we can directly use the response body bytes
        setState(() {
          _imageBytes = response.bodyBytes;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load heatmap: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouse Heatmap'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchHeatmap,
              child: const Text('Retry'),
            ),
          ],
        )
            : _imageBytes != null
            ? Image.memory(
          _imageBytes!,
          fit: BoxFit.contain,
        )
            : const Text('No image data received'),
      ),
    );
  }
}