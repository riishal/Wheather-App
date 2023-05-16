import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:provider/provider.dart';
import 'package:weather_app/viewModel/provider.dart';
import 'package:weather_app/view/splashscreen.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox('currentWeatherData');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DataProvider>(
      create: (context) => DataProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
