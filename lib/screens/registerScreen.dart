
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();



  @override
  void dispose(){
    _emailController.dispose();
    _password1Controller.dispose();
    _password2Controller.dispose();
    super.dispose();
  }



  Future signUp() async {
    
    if (_password1Controller.text.trim() == _password2Controller.text.trim()){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text.trim(),
     password: _password1Controller.text.trim());
     var uid = await FirebaseAuth.instance.currentUser!.uid;
     await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "selected_stocks": ["AMD", "TESLA"],
      "settings": {}
     });
     

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center
            ,children: [
            Icon(Icons.bar_chart_sharp,
            size: 80,),
            SizedBox(height: 50,),
            Text('Hello!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),),
            SizedBox(height: 10,),
            Center(
              child: Text('Stock APP',
              style: TextStyle( fontSize: 24),),
            ),
            SizedBox(height: 40,),
            
            
            // EMAIL TEXT FIELD 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[200],
                border: Border.all(color: Colors.white ), borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ' Email',
                    
              
                  ) ,
                ),
              ),
            ),
            SizedBox(height: 10,),


            // PASSWORD TEXT FIELD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[200],
                border: Border.all(color: Colors.white ), borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: _password1Controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ' Password',
                    
              
                  ) ,
                ),
              ),
            ),
            SizedBox(height: 10,),


            // PASSWORD TEXT FIELD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[200],
                border: Border.all(color: Colors.white ), borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: _password2Controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ' Confirm Password',
                    
              
                  ) ,
                ),
              ),
            ),
            SizedBox(height: 10,),
        

            // SIGN IN BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GestureDetector(
                onTap: signUp,
                child: Container(
                  padding: EdgeInsets.all(20),
                      
                  decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text('Sign up', style: TextStyle(color: Colors.white, 
                  fontWeight: FontWeight.bold, fontSize: 20),)),
                ),
              ),
            ),
            SizedBox(height: 10,),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already signed up? ', style: TextStyle(fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: widget.showLoginPage,
                  child: Text(' Login now!', style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),))
              ],
            )
        
              
          ]),
        ),
      ),
    );
  }
}