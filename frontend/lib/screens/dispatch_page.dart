import 'package:flutter/material.dart';
import '../models/pallet.dart';
import '../services/api_service.dart';

class DispatchPage extends StatefulWidget {
  final String sku;
  const DispatchPage({required this.sku, Key? key}) : super(key: key);

  @override
  State<DispatchPage> createState() => _DispatchPageState();
}

class _DispatchPageState extends State<DispatchPage> {
  final ApiService api = ApiService();
  late Future<List<Pallet>> palletsFuture;
  List<int> selected = [];

  @override
  void initState() {
    super.initState();
    palletsFuture = api.getPalletsBySku(widget.sku);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dispatch ${widget.sku}')),
      body: FutureBuilder<List<Pallet>>(
        future: palletsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final pallets = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: pallets
                        .map((p) => CheckboxListTile(
                              title: Text('Pallet ${p.id}'),
                              value: selected.contains(p.id),
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    selected.add(p.id);
                                  } else {
                                    selected.remove(p.id);
                                  }
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
                ElevatedButton(
                  onPressed: selected.isEmpty
                      ? null
                      : () async {
                          for (final id in selected) {
                            await api.dispatchPallet(id);
                          }
                          Navigator.pop(context);
                        },
                  child: const Text('Dispatch'),
                )
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
