import 'package:flutter/material.dart';
import 'package:stock_app/screens/loginScreen.dart';

import '../screens/registerScreen.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {


  bool showLoginPage = true;
  void toggleScreens(){
    setState(() {
      showLoginPage = !showLoginPage;
    });  
  }

  @override
  Widget build(BuildContext context) {
    
    if (showLoginPage){
      return LoginPage(showRegisterPage: toggleScreens);
    }
    else{
      return RegisterPage(showLoginPage: toggleScreens);
    }


    
  }
}