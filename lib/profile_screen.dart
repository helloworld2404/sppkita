import 'package:coba_spp/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coba_spp/custom_paint.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Loading...';
  String userEmail = 'Loading...';
  String userNis = 'Loading...';
  String userGender = '';

  void signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  Future<void> getUserGender() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    setState(() {
      userGender = userData['gender'] ?? ''; // Retrieve user's gender from Firestore
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getUserGender();
  }

  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    setState(() {
      userName = userData['first'] + ' ' + userData['last'];
      userEmail = user.email!;
      userNis = userData['nis'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF241BCC).withOpacity(0.9),
      body: Stack(
        children: [
          CustomPaint(
            painter: Painter(),
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: height * 0.01),
              SizedBox(
                height: height * 0.07,
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    Image.asset(
                      "images/notification.png",
                      height: height * 0.03,
                      width: width * 0.1,
                    ),
                  ],
                ),
              ),
                const SizedBox(height: 40),
                CircleAvatar(
                      radius: 70.0,
                      // Dynamically change avatar image based on user's gender
                      backgroundImage: AssetImage(userGender == 'l' ? 'images/man.png' : 'images/woman.png'),
                    ),
                const SizedBox(height: 20),
                itemProfile('Name', userName, CupertinoIcons.person),
                const SizedBox(height: 20),
                itemProfile('Email', userEmail, CupertinoIcons.mail),
                const SizedBox(height: 20,),
                itemProfile('Nis', userNis, CupertinoIcons.doc_person),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                         signUserOut(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Text('LOGOUT')
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.deepOrange.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10
            )
          ]
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
      ),
    );
  }
}