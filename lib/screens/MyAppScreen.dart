import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_app/providers/settingsProvider.dart';
import 'package:stock_app/auth/main_page.dart';


class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _themeNotifier = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Flutter Demo',

      themeMode: _themeNotifier.themeMode,
      // Define your themes here
      theme: ThemeData.light(
        useMaterial3: true,
        
  
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true
        
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

