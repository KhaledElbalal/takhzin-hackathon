import 'package:flutter/material.dart';
import '../models/product_instance.dart'; // <- Your existing model
import '../services/api_service.dart'; // <- Your existing API service

class ProductSearchPage extends StatefulWidget {
  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  late Future<List<ProductInstance>> _futureInstances;
  List<ProductInstance> _allInstances = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureInstances = ApiService().getProductInstances();
    _futureInstances.then((data) => setState(() => _allInstances = data));
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFCF1D51);

    final filtered = _searchQuery.isEmpty
        ? _allInstances
        : _allInstances
              .where(
                (p) =>
                    p.batchNumber?.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ??
                    false,
              )
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search by Batch Number'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: InputDecoration(
                labelText: 'Enter Batch Number',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Search Results
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text('No results found.'))
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        final product = filtered[index];
                        return ListTile(
                          leading: Icon(Icons.inventory, color: primaryColor),
                          title: Text('Product ID: ${product.product}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.batchNumber != null)
                                Text('Batch: ${product.batchNumber}'),
                              if (product.productionDate != null)
                                Text(
                                  'Production: ${product.productionDate!.toLocal().toIso8601String().split('T').first}',
                                ),
                              if (product.expiryDate != null)
                                Text(
                                  'Expiry: ${product.expiryDate!.toLocal().toIso8601String().split('T').first}',
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
