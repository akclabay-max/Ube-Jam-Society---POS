import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '/database/database.dart';
import '/widgets/receipt-card.dart';
import '/widgets/grid-background.dart';
import '/utils/receipt-export.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: GridBackground(
        cellSize: 20,
        lineColor: const Color(0x33d1d628),
        child: StreamBuilder<List<Receipt>>(
          stream: db.watchAllReceipts(),
          builder: (context, snapshot) {
            final receipts = snapshot.data ?? [];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header row with export button ──
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Receipts',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF602e9e),
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: receipts.isEmpty
                            ? null
                            : () => _export(context, receipts),
                        icon: const Icon(Icons.file_download_outlined),
                        label: const Text('Export Excel'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (receipts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Text('No receipts yet.'),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final available = constraints.maxWidth;

                        // Receipt cards are wider than item cards — target ~320px
                        const spacing = 16.0;
                        final columns =
                            (available / 320).floor().clamp(1, 4);

                        final cardWidth =
                            (available - (columns - 1) * spacing) / columns;

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            for (final receipt in receipts)
                              SizedBox(
                                width: cardWidth,
                                child: ReceiptCard(
                                  receiptNumber: receipt.receiptNumber,
                                  total: receipt.total,
                                  itemCount: _itemCount(receipt.itemsJson),
                                  date: receipt.createdAt,
                                  paymentMethod: receipt.paymentMethod,
                                  items: _items(receipt.itemsJson),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _export(BuildContext context, List<Receipt> receipts) async {
    try {
      await exportReceiptsToExcel(receipts);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  List<ReceiptItem> _items(String json) {
    final values = jsonDecode(json) as List<dynamic>;
    return values.map((value) {
      final item = value as Map<String, dynamic>;
      return ReceiptItem(
        name: item['name'] as String,
        qty: item['qty'] as int,
        price: (item['price'] as num).toDouble(),
        bulkDeal: item['bulkDeal'] as String?,
      );
    }).toList();
  }

  int _itemCount(String json) =>
      _items(json).fold(0, (total, item) => total + item.qty);
}