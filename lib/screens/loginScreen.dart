import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/screens/forgotPasswordScreen.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
     password: _passwordController.text.trim());
  }


  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center
              ,children: [
              Icon(Icons.bar_chart_sharp,
              size: 80,),
              SizedBox(height: 50,),
              Text('Hello Again',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),),
              SizedBox(height: 10,),
              Center(
                child: Text('Easy Stock',
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
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: ' Password',
                      
                
                    ) ,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:25.0),
                    child: GestureDetector(onTap:() {
      
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context){
                        return ForgotPasswordPage();
                      },),);
                      
                    }, child: Text('Forgot Password?', style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
      
              SizedBox(height: 10,),
          
      
              // SIGN IN BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: EdgeInsets.all(20),
                        
                    decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text('Sign In', style: TextStyle(color: Colors.white, 
                    fontWeight: FontWeight.bold, fontSize: 20),)),
                  ),
                ),
              ),
              SizedBox(height: 10,),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member? ', style: TextStyle(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: widget.showRegisterPage,
                    child: Text(' Register now!', style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),))
                ],
              )
          
                
            ]),
          ),
        ),
      ),
    );
  }
}