import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/auth/auth_page.dart';

import '../screens/stocksPage.dart';
import 'package:stock_app/screens/homePage.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return HomePage();
        }
        else {
          return AuthPage();
        }
      },),
    );
  }
}