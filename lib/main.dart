import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/digital_twin_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          DigitalTwinProvider()
            ..initialize(),
      child:
          const RiceTwinApp(),
    ),
  );
}

class RiceTwinApp
    extends StatelessWidget {
  const RiceTwinApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false,

      title:
          'RiceTwin AI',

      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
          seedColor:
              Colors.green,
        ),

        useMaterial3:
            true,

        scaffoldBackgroundColor:
            const Color(
          0xFFF5F7F5,
        ),

        cardTheme:
            CardThemeData(
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),
        ),
      ),

      home:
          const HomeScreen(),
    );
  }
}