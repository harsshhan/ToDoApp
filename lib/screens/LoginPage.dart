// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/services/Authentication.dart'; // Adjust path as needed

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email = '';
  var password = '';
  Authentication _authentication = Authentication();



  void _handleLogin() {
    if (email.isNotEmpty && password.isNotEmpty) {
      _authentication.new_user(email, password).then((_){
        Navigator.pushReplacementNamed(context,'/home');
      }).catchError((Error){
        print("Signin failed: $Error");
      });
    } else {
      // Handle empty email or password
      print('Email and password cannot be empty.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/login.png')),

              SizedBox(height: 70,),
              ElevatedButton.icon(
                onPressed: ()async {
                  try{
                  await _authentication.signInWithGoogle();
                  Navigator.pushReplacementNamed(context, '/home');
                  }
                  catch (error){
                    print(error);
                  }
                },
              
                icon: Image.asset(
                  "assets/images/google.jpg",
                  height: 25,
                  width: 25,
                ),
                label: Text("Continue with Google",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
