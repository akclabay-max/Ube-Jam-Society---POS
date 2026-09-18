import 'package:flutter/material.dart';
import '../widgets/grid-background.dart';
import '../widgets/settings-card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GridBackground(
        cellSize: 20,
        lineColor: const Color(0x33d1d628),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
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
                  SettingsCard(title: "Costs", entries: ["table fee","sticker paper","lamination paper"]),
                  SettingsCard(title: "Items", entries: ["Aster photocard","Enamel pin","Project Hail Mary"])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}