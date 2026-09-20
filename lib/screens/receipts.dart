import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:provider/provider.dart';

import '/database/database.dart';
import '/widgets/receipt-card.dart';
import '/widgets/grid-background.dart';

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
                  const Text(
                    'Receipts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF602e9e),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (receipts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Text('No receipts yet.'),
                    )
                  else
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        for (final receipt in receipts)
                          ReceiptCard(
                            receiptNumber: receipt.receiptNumber,
                            total: receipt.total,
                            itemCount: _itemCount(receipt.itemsJson),
                            date: receipt.createdAt,
                            paymentMethod: receipt.paymentMethod,
                            items: _items(receipt.itemsJson),
                          ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
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
