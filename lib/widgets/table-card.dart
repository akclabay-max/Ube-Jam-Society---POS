import 'package:flutter/material.dart';
import 'button.dart';   // 👈 your UJSButton widget

/// A single cell value in the table.
class TableCellData {
  const TableCellData(this.text, {this.isHeader = false, this.align = TextAlign.left});
  final String text;
  final bool isHeader;
  final TextAlign align;
}

class TableCard extends StatelessWidget {
  const TableCard({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
    this.subtitle,
    this.color = const Color(0xFF602e9e),
    this.width = 360,
    this.height = 270,
    // Header button
    this.buttonLabel,
    this.buttonIcon,
    this.onButtonPressed,
  });

  final String title;
  final String? subtitle;
  final Color color;
  final double width;
  final double height;

  /// Column headers, e.g. ['Item', 'Qty', 'Price'].
  final List<String> columns;

  /// Row data, each row must have the same length as [columns].
  final List<List<String>> rows;

  final String? buttonLabel;
  final IconData? buttonIcon;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title + Button ─────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1a1a1a),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (buttonLabel != null) ...[
                    const SizedBox(width: 8),
                    UJSButton(
                      label: buttonLabel!,
                      icon: buttonIcon,
                      color: color,
                      height: 36,
                      onPressed: onButtonPressed,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),

              // ── Table header ───────────────────────
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    for (final col in columns)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            col,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // ── Table rows (scrollable) ────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final row in rows)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              for (final cell in row)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      cell,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF1a1a1a),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}