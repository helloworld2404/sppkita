import 'package:coba_spp/components/my_button.dart';
import 'package:coba_spp/components/my_textfield.dart';
import 'package:coba_spp/custom_paint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn() async{
    //loading circle
    // showDialog(
    //   context: context, 
    //   builder: (context){
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    // },);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text,
      );
      // Navigator.pop(context);
    } on FirebaseAuthException catch (e){
      //WRONG EMAIL
      // Navigator.pop(context);
      if (e.code == 'user-not-found'){
        wrongEmailMessage();
      }
      //WRONG PASSWORD
      else if(e.code == 'wrong-password'){
        wrongPasswordMessage();
      }
    }
  }

  //wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context, 
      builder: (context){
        return const AlertDialog(
          title: Text('Incorrect Email'),
        );
      },
    );
  }
  void wrongPasswordMessage() {
    showDialog(
      context: context, 
      builder: (context){
        return const AlertDialog(
          title: Text('Incorrect Password'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF241BCC).withOpacity(0.9),
      body: SafeArea(
        child: Center(
          child: CustomPaint(
            painter: Painter(),
            child: Column(
              children: [
                SizedBox(height: 200,),
                Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 25,),

                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    ),
                ),
                SizedBox(height: 25,),

                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                SizedBox(height: 25,),

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                SizedBox(height: 25,),

                MyButton(
                  onTap: signUserIn,
                ),
              ],
            ),
         ),
        ),
      ),
    );
  }
}