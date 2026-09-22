import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../database/database.dart';

Future<void> exportReceiptsToExcel(List<Receipt> receipts) async {
  final excel = Excel.createExcel();

  // ── Sheet 1: Line items ─────────────────────
  final itemsSheet = excel['Receipts'];
  excel.setDefaultSheet('Receipts');

  itemsSheet.appendRow([
    TextCellValue('Receipt #'),
    TextCellValue('Date'),
    TextCellValue('Payment'),
    TextCellValue('Item'),
    TextCellValue('Qty'),
    TextCellValue('Unit Price'),
    TextCellValue('Line Total'),
    TextCellValue('Contributor'),
    TextCellValue('Bulk Deal'),
  ]);

  for (final receipt in receipts) {
    final items = (jsonDecode(receipt.itemsJson) as List)
        .cast<Map<String, dynamic>>();

    for (final item in items) {
      final qty = (item['qty'] as num).toInt();
      final price = (item['price'] as num).toDouble();
      final lineTotal = qty * price;

      itemsSheet.appendRow([
        TextCellValue(receipt.receiptNumber),
        TextCellValue(_formatDate(receipt.createdAt)),
        TextCellValue(receipt.paymentMethod),
        TextCellValue(item['name']?.toString() ?? ''),
        IntCellValue(qty),
        DoubleCellValue(price),
        DoubleCellValue(lineTotal),
        TextCellValue(item['contributor']?.toString() ?? ''),
        TextCellValue(item['bulkDeal']?.toString() ?? ''),
      ]);
    }
  }

  // ── Sheet 2: Summary per receipt ────────────
  final summarySheet = excel['Summary'];
  summarySheet.appendRow([
    TextCellValue('Receipt #'),
    TextCellValue('Date'),
    TextCellValue('Payment'),
    TextCellValue('Total'),
    TextCellValue('Item Count'),
  ]);

  for (final receipt in receipts) {
    final items = (jsonDecode(receipt.itemsJson) as List)
        .cast<Map<String, dynamic>>();
    final totalQty = items.fold<int>(
      0,
      (sum, item) => sum + (item['qty'] as num).toInt(),
    );

    summarySheet.appendRow([
      TextCellValue(receipt.receiptNumber),
      TextCellValue(_formatDate(receipt.createdAt)),
      TextCellValue(receipt.paymentMethod),
      DoubleCellValue(receipt.total),
      IntCellValue(totalQty),
    ]);
  }

  // ── Save to a temp file ─────────────────────
  final bytes = excel.encode();
  if (bytes == null) {
    throw Exception('Failed to encode Excel file');
  }

  final dir = await getTemporaryDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final file = File('${dir.path}/receipts_$timestamp.xlsx');
  await file.writeAsBytes(bytes, flush: true);

  // ── Open the share sheet ────────────────────
  await Share.shareXFiles(
    [XFile(file.path)],
    subject: 'UJS POS Receipts Export',
    text: 'Receipts export from Ube Jam Society POS',
  );
}

String _formatDate(DateTime d) {
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}