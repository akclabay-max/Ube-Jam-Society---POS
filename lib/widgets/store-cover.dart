import 'package:flutter/material.dart';

class StorefrontAwning extends StatelessWidget {
  const StorefrontAwning({super.key});

  @override
  Widget build(BuildContext context) {
    const int stripeCount = 10;              // how many U shapes
    const Color colorA = Color(0xFFa78ae8);  // red
    const Color colorB = Color(0xFFd1d628);  // white

    return SizedBox(
      height: 60,
      child: Row(
        children: List.generate(stripeCount, (index) {
          final isEven = index.isEven;
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isEven ? colorA : colorB,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}