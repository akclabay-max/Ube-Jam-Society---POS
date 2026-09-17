import 'package:flutter/material.dart';
import 'button.dart';   

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.number,
    this.subtitle,
    this.color = const Color(0xFF602e9e),
    this.onTap,
    this.width = 170,
    this.height = 180,
    this.buttonLabel,
    this.buttonIcon,
    this.onButtonPressed,
    this.buttonColor,
    this.secondaryButtonColor,
    this.secondaryButtonLabel,
    this.secondaryButtonIcon,
    this.onSecondaryButtonPressed,
  });

  final String title;
  final IconData icon;
  final String number;
  final String? subtitle;
  final Color color;
  final VoidCallback? onTap;
  final double width;
  final double height;

  final String? buttonLabel;
  final IconData? buttonIcon;
  final VoidCallback? onButtonPressed;

  final String? secondaryButtonLabel;
  final IconData? secondaryButtonIcon;
  final VoidCallback? onSecondaryButtonPressed;
  final Color? buttonColor;
  final Color? secondaryButtonColor;

  @override
  Widget build(BuildContext context) {
    final hasPrimary = buttonLabel != null;
    final hasSecondary = secondaryButtonLabel != null;
    final hasAnyButton = hasPrimary || hasSecondary;

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title + Icon ───────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a1a1a),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 12),
                    ),
                  ],
                ),

                // ── Subtitle ───────────────────────────
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

                const Spacer(),

                // ── Number ─────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    number,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),

                // ── Optional Button(s) ─────────────────
                if (hasAnyButton) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (hasPrimary)
                        Expanded(
                          child: UJSButton(
                            label: buttonLabel!,
                            icon: buttonIcon,
                            color: buttonColor ?? color,
                            height: 30,
                            onPressed: onButtonPressed,
                          ),
                        ),
                      if (hasPrimary && hasSecondary)
                        const SizedBox(width: 8),
                      if (hasSecondary)
                        Expanded(
                          child: UJSButton(
                            label: secondaryButtonLabel!,
                            icon: secondaryButtonIcon,
                            color: secondaryButtonColor ?? color,
                            height: 30,
                            isOutlined: true,
                            onPressed: onSecondaryButtonPressed,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}