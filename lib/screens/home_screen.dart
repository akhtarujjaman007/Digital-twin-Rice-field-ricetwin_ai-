import 'package:flutter/material.dart';

import 'analytics_screen.dart';
import 'dashboard_screen.dart';
import 'digital_twin_screen.dart';
import 'disease_screen.dart';

class HomeScreen
    extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  int selectedIndex = 0;

  final screens = const [
    DashboardScreen(),
    DigitalTwinScreen(),
    DiseaseScreen(),
    AnalyticsScreen(),
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.eco,
            ),

            SizedBox(
              width: 8,
            ),

            Text(
              'RiceTwin AI',
            ),
          ],
        ),
      ),

      body:
          screens[selectedIndex],

      bottomNavigationBar:
          NavigationBar(
        selectedIndex:
            selectedIndex,
        onDestinationSelected:
            (index) {
          setState(() {
            selectedIndex =
                index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.dashboard_outlined,
            ),
            selectedIcon: Icon(
              Icons.dashboard,
            ),
            label: 'Dashboard',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.map_outlined,
            ),
            selectedIcon: Icon(
              Icons.map,
            ),
            label: 'Digital Twin',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.biotech_outlined,
            ),
            selectedIcon: Icon(
              Icons.biotech,
            ),
            label: 'Disease AI',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.analytics_outlined,
            ),
            selectedIcon: Icon(
              Icons.analytics,
            ),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}