import 'package:flutter/material.dart';

class ReceiptItem {
  const ReceiptItem({
    required this.name,
    required this.qty,
    required this.price,
  });

  final String name;
  final int qty;
  final double price;

  double get lineTotal => qty * price;
}

class ReceiptCard extends StatefulWidget {
  const ReceiptCard({
    super.key,
    required this.receiptNumber,
    required this.total,
    required this.itemCount,
    required this.date,
    this.items = const [],
    this.color = const Color(0xFF602e9e),
    this.width = 350,
    this.onView,
  });

  final String receiptNumber;
  final double total;
  final int itemCount;
  final DateTime date;
  final List<ReceiptItem> items;
  final Color color;
  final double width;
  final VoidCallback? onView;

  @override
  State<ReceiptCard> createState() => _ReceiptCardState();
}

class _ReceiptCardState extends State<ReceiptCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color;

    return SizedBox(
      width: widget.width,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.receiptNumber,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1a1a1a),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.receipt_long, color: color, size: 18),
                  ),
                ],
              ),

              const SizedBox(height: 4),
              Text(
                _formatDate(widget.date),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),

              const SizedBox(height: 12),

              // ── Summary ────────────────────────────
              Row(
                children: [
                  Text(
                    '${widget.itemCount} items',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const Spacer(),
                  Text(
                    '₱${widget.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),

              // ── View Particulars toggle ────────────
              const SizedBox(height: 8),
              InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                        color: color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'View Particulars',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFa78ae8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Expandable particulars ─────────────
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity, height: 0),
                secondChild: _buildParticulars(color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticulars(Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 16),

          // Header row
          Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text(
                  'Item',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: Text(
                  'Qty',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Text(
                  'Price',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Item rows
          if (widget.items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No items to display',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            )
          else
            for (final item in widget.items) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1a1a1a),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.qty}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1a1a1a),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '₱${item.lineTotal.toStringAsFixed(2)}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a1a1a),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

          // Total line
          if (widget.items.isNotEmpty) ...[
            const Divider(height: 16),
            Row(
              children: [
                const Expanded(
                  flex: 5,
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '₱${widget.total.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}