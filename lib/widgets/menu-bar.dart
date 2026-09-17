import 'package:flutter/material.dart';

class UJSMenuBar extends StatelessWidget {
  const UJSMenuBar({
    super.key,
    this.selected,              // 👈 current screen label, for highlighting
    this.onItemSelected,        // 👈 callback
  });

  final String? selected;
  final void Function(String label)? onItemSelected;

  @override
  Widget build(BuildContext context) {
    const Color colorA = Color(0xFFa78ae8);
    const Color colorB = Color(0xFFd1d628);
    const Color colorC = Color(0xFF602e9e);
    const Color colorD = Color(0xFFfffeec);

    final items = <_MenuEntry>[
      _MenuEntry('Home', Icons.home),
      _MenuEntry('Receipts', Icons.receipt),
      _MenuEntry('Scan', Icons.document_scanner_outlined, isCenter: true),
      _MenuEntry('Items', Icons.grid_view_rounded),
      _MenuEntry('Settings', Icons.settings),
    ];

    return SizedBox(
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 80,
            color: colorB,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final item in items)
                  _MenuItem(
                    icon: item.icon,
                    label: item.label,
                    color: item.isCenter ? colorD : colorC,
                    isCenter: item.isCenter,
                    circleColor: item.isCenter ? colorC : null,
                    onTap: () => onItemSelected?.call(item.label),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuEntry {
  const _MenuEntry(this.label, this.icon, {this.isCenter = false});
  final String label;
  final IconData icon;
  final bool isCenter;
}


class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,            
    this.isCenter = false,
    this.circleColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool isCenter;
  final Color? circleColor;

  @override
  Widget build(BuildContext context) {
    final content = isCenter
        ? Transform.translate(
            offset: const Offset(0, -20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 50,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(height: 4),
                Text(label, style: TextStyle(color: circleColor, fontSize: 12)),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color, fontSize: 12)),
            ],
          );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: content,
      ),
    );
  }
}

