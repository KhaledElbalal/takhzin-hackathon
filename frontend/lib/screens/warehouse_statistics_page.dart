import 'package:flutter/material.dart';
import '../models/pallet.dart';
import '../services/api_service.dart';

class WarehouseStatisticsPage extends StatefulWidget {
  @override
  _WarehouseStatisticsPageState createState() =>
      _WarehouseStatisticsPageState();
}

class _WarehouseStatisticsPageState extends State<WarehouseStatisticsPage> {
  late Future<List<Pallet>> _futurePallets;
  final ApiService _service = ApiService();

  static const Color takhzinPrimary = Color(0xFFCF1D51);
  static const Color primaryLight = Color(0xFFFFCDD2);
  static const Color pageBackground = Colors.white;
  static const Color contentBackground = Color(0xFFF3F4F6);
  static const Color textPrimary = Color(0xFF1F2937);

  @override
  void initState() {
    super.initState();
    _futurePallets = _service.getPallets();
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: takhzinPrimary,
            fontSize: 15,
          ),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: textPrimary.withOpacity(0.85),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPalletCard(Pallet pallet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pallet ID: ${pallet.id}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: takhzinPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: pallet.reserved
                      ? primaryLight.withOpacity(0.3)
                      : takhzinPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  pallet.reserved ? 'Used' : 'Empty',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: takhzinPrimary,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 24, color: primaryLight.withOpacity(0.4)),
          _buildDetailRow('Reserved', pallet.reserved ? 'Yes' : 'No'),
          _buildDetailRow('Reserved Customer', pallet.reservedCustomer),
          _buildDetailRow('Supplier', pallet.supplier),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                pallet.reserved
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                color: pallet.reserved ? takhzinPrimary : Colors.redAccent,
              ),
              SizedBox(width: 8),
              Text(
                pallet.reserved ? 'Reserved' : 'Not Reserved',
                style: TextStyle(
                  color: textPrimary.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: takhzinPrimary,
        centerTitle: true,
        title: Text(
          'Warehouse Statistics',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        elevation: 3,
        shadowColor: primaryLight.withOpacity(0.6),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Pallet>>(
        future: _futurePallets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: takhzinPrimary),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No pallets found.',
                style: TextStyle(
                  color: textPrimary.withOpacity(0.7),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else {
            final pallets = snapshot.data!;
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: contentBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Header
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Text(
                          'Used Pallets: ${pallets.where((p) => p.reserved).length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                        SizedBox(width: 24),
                        Container(
                          width: 12,
                          height: 12,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Text(
                          'Empty Pallets: ${pallets.where((p) => !p.reserved).length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Responsive Grid
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = constraints.maxWidth > 1400
                              ? 4
                              : constraints.maxWidth > 1000
                              ? 3
                              : constraints.maxWidth > 600
                              ? 2
                              : 1;
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 1.5,
                                ),
                            itemCount: pallets.length,
                            itemBuilder: (context, index) {
                              return _buildPalletCard(pallets[index]);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
