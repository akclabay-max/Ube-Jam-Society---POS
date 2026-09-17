import 'package:flutter/material.dart';
import '/widgets/store-cover.dart';
import '/widgets/menu-bar.dart';
import '/widgets/grid-background.dart';
import '/widgets/dashboard-card.dart';
import '/widgets/table-card.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,   // 👈 left-align title
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF602e9e),
            ),
          ),
          const SizedBox(height: 16),                    // 👈 gap below title

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              DashboardCard(
                title: 'Profit',
                subtitle: 'Current profit',
                icon: Icons.arrow_upward_outlined,
                color: const Color.fromARGB(255, 3, 147, 25),
                number: '₱12,450',
                width: 160,
                height: 130,
              ),
              DashboardCard(
                title: 'Earnings',
                subtitle: 'For current event',
                icon: Icons.attach_money,
                color: const Color.fromARGB(255, 33, 162, 24),
                number: '₱12,450',
                width: 175,
                height: 130,
              ),
              DashboardCard(
                title: 'Production Costs',
                icon: Icons.wallet_sharp,
                color: const Color.fromARGB(255, 205, 28, 28),
                number: '₱12,450',
                width: 500,
                height: 150,
                buttonLabel: 'View Breakdown',
                secondaryButtonLabel: '+ Add Cost',
              ),
              TableCard(
                title: 'Contributors',
                subtitle: 'Shares between contributors',
                columns: const ['Name', 'Share'],
                rows: const [
                  ['Aster', '₱500'],
                  ['Miisomaru', '₱300'],
                  ['Bea', '₱400'],
                  ['Christien', '₱400'],
                  ['Zoe', '₱400'],
                ],
                buttonLabel: 'Add Contributor',
                buttonIcon: Icons.add,
                onButtonPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}