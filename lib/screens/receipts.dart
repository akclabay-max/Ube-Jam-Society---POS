import 'package:flutter/material.dart';
import '/widgets/receipt-card.dart';
import '/widgets/grid-background.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      body: GridBackground(
        cellSize: 20,
        lineColor: const Color(0x33d1d628),
        child: SingleChildScrollView(
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
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ReceiptCard(
                    receiptNumber: 'UJSR-003',
                    total: 50.99,
                    itemCount: 3,
                    date: DateTime.now(),
                    items:  [
                      ReceiptItem(name: 'Amaze Amaze Amaze', qty: 1, price: 30.99),
                      ReceiptItem(name: 'Koaruhana Pin', qty: 2, price: 20.00),
                    ],
                    onView: () {
                      // optional: navigate to full receipt page
                    },
                  ),
                  ReceiptCard(
                    receiptNumber: 'UJSR-002',
                    total: 49.99,
                    itemCount: 3,
                    date: DateTime.now(),
                    items:  [
                      ReceiptItem(name: 'Fist My Bump', qty: 1, price: 29.99),
                      ReceiptItem(name: 'Words of Encouragement', qty: 2, price: 10.00),
                    ],
                    onView: () {
                      // optional: navigate to full receipt page
                    },
                  ),
                  ReceiptCard(
                    receiptNumber: 'UJSR-001',
                    total: 49.99,
                    itemCount: 3,
                    date: DateTime.now(),
                    items:  [
                      ReceiptItem(name: 'Meow Mao Mao', qty: 1, price: 29.99),
                      ReceiptItem(name: 'Frog Jinshi', qty: 2, price: 10.00),
                    ],
                    onView: () {
                      // optional: navigate to full receipt page
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}