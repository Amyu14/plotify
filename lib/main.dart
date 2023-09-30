import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plotify/constants.dart';
import 'package:plotify/screens/chart_grid_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  await windowManager.waitUntilReadyToShow();
  await WindowManager.instance.setMinimumSize(const Size(1000, 600));
  await WindowManager.instance.setSize(const Size(1300, 600));


  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Plotify",
      debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 181, 250)),
            textTheme: GoogleFonts.nunitoTextTheme(
              
            ).copyWith(
              titleLarge: GoogleFonts.nunito(
                fontSize: 45,
                color: titleColor
              ),
              titleMedium: GoogleFonts.nunito(
                fontSize: 20,
                color: titleColor
              ),
              titleSmall: GoogleFonts.nunito(
                fontSize: 15,
                color: titleColor
              ),
            ),),
        home: const ChartGridScreen());
  }
}
