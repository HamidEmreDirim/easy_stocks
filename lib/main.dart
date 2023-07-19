import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stock_app/auth/main_page.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';



Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.ptSerifTextTheme()
    ),
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}