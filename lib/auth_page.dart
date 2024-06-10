import 'package:coba_spp/home_screen.dart';
import 'package:coba_spp/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if(snapshot.hasData){
            return HomeScreen();
          }
          //user is not logged in
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}