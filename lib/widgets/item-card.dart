import 'dart:io';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.title,
    required this.price,
    this.imageUrl,
    this.imageAsset,
    this.imagePath,    
    this.imageHeight = 120,
    this.width = 167,
    this.height = 235,
    this.color = const Color(0xFF602e9e),
    this.onViewDetails,
    // ── Selection mode ─────────────────────────
    this.quantity,
    this.onIncrement,
    this.onDecrement,
    // ── Ellipsis menu ──────────────────────────
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final double price;
  final String? imageUrl;
  final String? imageAsset;
  final String? imagePath; 
  final double imageHeight;
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onViewDetails;
  final int? quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  bool get _showStepper => quantity != null;
  bool get _showMenu => !_showStepper;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: InkWell(
          onTap: _showStepper ? onIncrement : onViewDetails,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image + ellipsis overlay ───────────
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: double.infinity,
                        height: imageHeight,
                        child: _buildImage(),
                      ),
                    ),

                    if (_showMenu)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: _MenuButton(
                          color: color,
                          onViewDetails: onViewDetails,
                          onEdit: onEdit,
                          onDelete: onDelete,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Title ──────────────────────────────
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a1a),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // ── Price ──────────────────────────────
                Text(
                  '₱${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),

                const Spacer(),

                // ── Stepper (only in selection mode) ───
                if (_showStepper)
                  Align(
                    alignment: Alignment.centerRight,
                    child: _QuantityStepper(
                      quantity: quantity!,
                      color: color,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
   if (imagePath != null && imagePath!.isNotEmpty) {
    final exists = File(imagePath!).existsSync();
    debugPrint('ItemCard image: $imagePath exists=$exists');
    return Image.file(
      File(imagePath!),
      fit: BoxFit.cover,
      key: ValueKey(imagePath),
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
  if (imageUrl != null) {
    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return _placeholder();
      },
    );
  }
  if (imageAsset != null) {
    return Image.asset(
      imageAsset!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
  return _placeholder();
}

  Widget _placeholder() {
    return Container(
      color: color.withOpacity(0.10),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 36,
          color: color.withOpacity(0.5),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.color,
    this.onViewDetails,
    this.onEdit,
    this.onDelete,
  });

  final Color color;
  final VoidCallback? onViewDetails;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,              
      height: 24,         
      child:Material(
      color: Colors.white.withOpacity(0.9),
      shape: const CircleBorder(),
      elevation: 2,
      child: PopupMenuButton<String>(
        tooltip: 'Options',
        icon: Icon(Icons.more_horiz, size: 14, color: color),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onSelected: (value) {
          switch (value) {
            case 'view':
              onViewDetails?.call();
              break;
            case 'edit':
              onEdit?.call();
              break;
            case 'delete':
              onDelete?.call();
              break;
          }
        },
        itemBuilder: (context) => [
          if (onViewDetails != null)
            const PopupMenuItem(
              value: 'view',
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.info_outline, size: 14),
                title: Text('View Details'),
              ),
            ),
          if (onEdit != null)
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.edit_outlined, size: 18),
                title: Text('Edit'),
              ),
            ),
          if (onDelete != null)
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.delete_outline,
                    size: 18, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ),
        ],
      ),
    ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.color,
    this.onIncrement,
    this.onDecrement,
  });

  final int quantity;
  final Color color;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepperButton(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$quantity',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          _stepperButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }

  Widget _stepperButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}