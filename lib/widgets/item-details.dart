import 'package:flutter/material.dart';
import '../database/database.dart';
import '../models/item-extensions.dart';
import 'dart:io';

Future<void> showItemDetails(BuildContext context, Item item) {
  return showDialog(
    context: context,
    builder: (_) => ItemDetailsDialog(item: item),
  );
}

class ItemDetailsDialog extends StatelessWidget {
  const ItemDetailsDialog({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF602e9e),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row('Price', '₱${item.finalPrice.toStringAsFixed(2)}'),
                    if (item.discount > 0) _row('Discount', '${item.discount}%'),
                    _row('Stock', '${item.stock}'),
                    if (item.contributor != null)
                      _row('Contributor', item.contributor!),
                    if (item.fandom != null) _row('Fandom', item.fandom!),
                    if (item.category != null) _row('Category', item.category!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1a1a1a),
              ),
            ),
          ),
        ],
      ),
    );
  }
}