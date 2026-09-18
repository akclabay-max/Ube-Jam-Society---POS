import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/store-cover.dart';
import 'widgets/menu-bar.dart';
import 'widgets/grid-background.dart';
import 'widgets/dashboard.dart';
import 'widgets/dashboard-card.dart';
import 'widgets/table-card.dart';
import 'screens/receipts.dart';
import 'screens/scan-add.dart';
import 'screens/items.dart';
import 'screens/settings.dart';
import 'database/database.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  runApp( 
    Provider<AppDatabase>.value(
    value: database,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UJS POS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFfffeec),
      ),
      home: const MyHomePage(title: 'Ube Jam Society'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final _labels = const ['Home', 'Receipts', 'Scan', 'Items', 'Settings'];

  final _screens = const [
    DashboardTab(),
    ReceiptsScreen(),
    ScanAddScreen(),
    ItemsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridBackground(
        cellSize: 20,
        lineColor: const Color(0x33d1d628),
        child: Column(
          children: [
            const StorefrontAwning(),
            Expanded(
              child: IndexedStack(      
                index: _currentIndex,
                children: _screens,
              ),
            ),
            UJSMenuBar(
              selected: _labels[_currentIndex],
              onItemSelected: (label) {
                final index = _labels.indexOf(label);
                if (index != -1) {
                  setState(() => _currentIndex = index);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}