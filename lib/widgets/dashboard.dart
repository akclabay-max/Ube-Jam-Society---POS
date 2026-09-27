import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '/widgets/store-cover.dart';
import '/widgets/menu-bar.dart';
import '/widgets/grid-background.dart';
import '/widgets/dashboard-card.dart';
import '/widgets/table-card.dart';
import '/widgets/cost-form.dart';
import '/widgets/earnings-form.dart';
import '/database/database.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF602e9e),
            ),
          ),
          const SizedBox(height: 16), 

          LayoutBuilder(
          builder: (context, constraints) {
            final available = constraints.maxWidth;
            const spacing = 16.0;

            // Dashboard cards are bigger — target ~360px wide.
            final columns = (available / 360).floor().clamp(1, 3);
            final cardWidth =
                (available - (columns - 1) * spacing) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                // ── Profits card ─────────────────────
                SizedBox(
                  width: cardWidth,
                  child: StreamBuilder<List<ProductionCost>>(
                    stream: db.watchCostsBetween(
                      DateTime.now().subtract(const Duration(days: 90)),
                      DateTime.now(),
                    ),
                    builder: (context, costSnap) {
                      return StreamBuilder<List<Earning>>(
                        stream: db.watchAllEarnings(),
                        builder: (context, earnSnap) {
                          final costs = costSnap.data ?? [];
                          final earnings = earnSnap.data ?? [];
                          final totalCosts = costs.fold<double>(0, (s, c) => s + c.amount);
                          final totalEarnings = earnings.fold<double>(0, (s, e) => s + e.amount);
                          final profit = totalEarnings - totalCosts;

                          return DashboardCard(
                            title: 'Actual Profits',
                            icon: Icons.storefront_outlined,
                            color: profit >= 0
                                ? const Color(0xFF1B8E3D)
                                : const Color(0xFFCD1C1C),
                            number: '₱${profit.toStringAsFixed(2)}',
                            // 👇 pass nothing — parent SizedBox handles width
                            height: 110,
                          );
                        },
                      );
                    },
                  ),
                ),

                // ── Costs card ────────────────────────
                SizedBox(
                  width: cardWidth,
                  child: StreamBuilder<List<ProductionCost>>(
                    stream: db.watchCostsBetween(
                      DateTime.now().subtract(const Duration(days: 90)),
                      DateTime.now(),
                    ),
                    builder: (context, snap) {
                      final costs = snap.data ?? [];
                      final total = costs.fold<double>(0, (s, c) => s + c.amount);
                      return DashboardCard(
                        title: 'Production Costs',
                        icon: Icons.wallet_sharp,
                        color: const Color(0xFFCD1C1C),
                        number: '₱${total.toStringAsFixed(2)}',
                        height: 150,
                        buttonLabel: 'View Breakdown',
                        secondaryButtonLabel: '+ Add Cost',
                        onButtonPressed: () => _showCostBreakdown(context, costs),
                        onSecondaryButtonPressed: () => showCostForm(context),
                      );
                    },
                  ),
                ),

                // ── Earnings card ────────────────────
                SizedBox(
                  width: cardWidth,
                  child: StreamBuilder<List<Earning>>(
                    stream: db.watchAllEarnings(),
                    builder: (context, snap) {
                      final earnings = snap.data ?? [];
                      final total = earnings.fold<double>(0, (s, e) => s + e.amount);
                      return DashboardCard(
                        title: 'Earnings',
                        icon: Icons.attach_money,
                        color: const Color(0xFF1B8E3D),
                        number: '₱${total.toStringAsFixed(2)}',
                        height: 150,
                        buttonLabel: 'View Breakdown',
                        secondaryButtonLabel: '+ Add Earning',
                        onButtonPressed: () => _showEarningsBreakdown(context, earnings),
                        onSecondaryButtonPressed: () => showEarningsForm(context),
                      );
                    },
                  ),
                ),

                // ── Contributors table ──────────────
                SizedBox(
                  width: cardWidth,
                  child: StreamBuilder<List<SettingsEntry>>(
                    stream: db.watchEntriesFor('contributor'),
                    builder: (context, contributorSnapshot) {
                      return StreamBuilder<List<Receipt>>(
                        stream: db.watchAllReceipts(),
                        builder: (context, receiptSnapshot) {
                          final contributors = contributorSnapshot.data ?? [];
                          final receipts = receiptSnapshot.data ?? [];
                          return TableCard(
                            title: 'Contributors',
                            subtitle: 'Shares from sold items',
                            columns: const ['Name', 'Share'],
                            rows: _contributorRows(contributors, receipts),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        ],
      ),
    );
  }
}

Future<void> _showCostBreakdown(
  BuildContext context,
  List<ProductionCost> costs,
) async {
  await showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Production cost breakdown'),
      content: SizedBox(
        width: 520,
        child: costs.isEmpty
            ? const Text('No production costs recorded.')
            : ListView(
                shrinkWrap: true,
                children: [
                  for (final cost in costs)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(cost.particular),
                      subtitle: Text(
                        '${cost.qty} · ${_date(cost.startDate)} to ${_date(cost.endDate)}',
                      ),
                      trailing: Text('₱${cost.amount.toStringAsFixed(2)}'),
                    ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

Future<void> _showEarningsBreakdown(
  BuildContext context,
  List<Earning> earnings,
) async {
  await showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Earnings breakdown'),
      content: SizedBox(
        width: 520,
        child: earnings.isEmpty
            ? const Text('No earnings recorded.')
            : ListView(
                shrinkWrap: true,
                children: [
                  for (final earning in earnings)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(earning.source),
                      subtitle: Text(
                        '${_date(earning.startDate)} to ${_date(earning.endDate)}'
                        '${earning.receiptId == null ? '' : ' · ${earning.receiptId}'}',
                      ),
                      trailing: Text('₱${earning.amount.toStringAsFixed(2)}'),
                    ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

String _date(DateTime value) =>
    '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

List<List<String>> _contributorRows(
  List<SettingsEntry> contributors,
  List<Receipt> receipts,
) {
  final shares = <String, double>{
    for (final contributor in contributors) contributor.value: 0,
  };

  for (final receipt in receipts) {
    final values = (jsonDecode(receipt.itemsJson) as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .toList();
    final gross = values.fold<double>(
      0,
      (sum, item) =>
          sum + (item['price'] as num).toDouble() * (item['qty'] as num),
    );
    if (gross <= 0) continue;

    for (final item in values) {
      final contributor = item['contributor'] as String?;
      if (contributor == null || !shares.containsKey(contributor)) continue;
      final lineGross =
          (item['price'] as num).toDouble() * (item['qty'] as num);
      shares[contributor] =
          shares[contributor]! + receipt.total * lineGross / gross;
    }
  }

  return shares.entries
      .map((entry) => [entry.key, '₱${entry.value.toStringAsFixed(2)}'])
      .toList();
}
