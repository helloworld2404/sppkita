import 'package:coba_spp/about_us.dart';
import 'package:coba_spp/coba_postman.dart';
import 'package:coba_spp/crud_tagihan.dart';
import 'package:coba_spp/google_map_page.dart';
import 'package:coba_spp/map_page.dart';
import 'package:coba_spp/payment_screen.dart';
import 'package:coba_spp/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coba_spp/custom_paint.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = FirebaseFirestore.instance;
  var height, width;
  final user = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot<Map<String, dynamic>>> tagihanStream = Stream.empty();

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  Future<int> getTagihan() async {
    var userId = user.uid;
    var apiService = ApiService(baseUrl: 'http://sppkita.skom.id/api');
    //
    var pembayaranData = await apiService.fetchTotalPembayaran(userId);
    
    // Initialize total tagihan
    num totalTagihan = 0;

    // Calculate total tagihan from fetched data
    pembayaranData.forEach((item) {
      totalTagihan += (item['spp']['nominal'] ?? 0).toInt();
    });

    return totalTagihan.toInt();
  }



  Future<String> getUserGender() async {
    var userId = user.uid;
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      var userData = userDoc.data();
      var gender = userData?['gender'];
      return gender ?? ""; // Return gender or an empty string if not found
    } else {
      return ""; // Return an empty string if user document doesn't exist
    }
  }

  Future<String> getUsername() async {
    var userId = user.uid;
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      var userData = userDoc.data();
      var first = userData?['first'];
      var last = userData?['last']; 
      if (first != null) {
        return "$first $last";
      } else {
        return "No 'tagihan' data found for the current user.";
      }
    } else {
      return "No data found for the current user.";
    }
  }
  @override
  void initState() {
    super.initState();
    getTagihan();
    tagihanStream = FirebaseFirestore.instance
        .collection('Tagihan')
        .where('Id_siswa', isEqualTo: user.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: tagihanStream, 
        builder: (context,snapshots){
          if(snapshots.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshots.hasError){
            return const Center(
              child: Text("ERROR"),
            );
          }else{
            height = MediaQuery.of(context).size.height;
            width = MediaQuery.of(context).size.width;
            var _data = snapshots.data!.docs;

            return Container(
                color: Color(0xFF241BCC).withOpacity(0.9),
                height: height,
                width: width,
                child: CustomPaint(
                  painter: Painter(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.4,
                        width: width,
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.06,
                            ),
                            SizedBox(
                              height: height * 0.06,
                              width: width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("05 March 2024",
                                      style: GoogleFonts.lexend(
                                        fontSize: width * 0.032,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        ),
                                      ),
                                      FutureBuilder<String>(
                                        future: getUsername(), // Assuming you have a method to fetch the user's name
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              'Error: ${snapshot.error}',
                                              style: TextStyle(color: Colors.red),
                                            );
                                          } else {
                                            return Text(
                                              snapshot.data ?? 'No data available',
                                              style: GoogleFonts.lexend(
                                                fontSize: width * 0.048,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  FutureBuilder<String>(
                                    future: getUserGender(),
                                    builder: (context, genderSnapshot) {
                                      if (genderSnapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (genderSnapshot.hasError) {
                                        return Text(
                                          'Error: ${genderSnapshot.error}',
                                          style: TextStyle(color: Colors.red),
                                        );
                                      } else {
                                        String gender = genderSnapshot.data ?? "";
                                        String imagePath = (gender == "l") ? "images/man.png" : "images/woman.png";
                                        
                                        return GestureDetector(
                                          onTap: () {
                                            // Navigate to another page
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ProfileScreen()),
                                            );
                                          },
                                          child: Container(
                                            height: height * 0.06,
                                            width: width * 0.12,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(17),
                                              color: Colors.white,
                                            ),
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Image.asset(
                                                imagePath,
                                                height: height * 0.05,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.05,

                              ),
                              SizedBox(
                                height: height * 0.06,
                                width: width * 0.8,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Payment Summary",
                                        style: GoogleFonts.lexend(
                                          fontSize: width * 0.03,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),),
                                        Text("Pembayaran SPP",
                                        style: GoogleFonts.lexend(
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),),
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.only(
                                      top: height * 0.03, right: width * 0.05),
                                      child: Row(children: [
                                        Text("Rp. 200.000",
                                        style: GoogleFonts.lexend(
                                          fontSize: width * 0.035,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),),
                                        Text("/bln",
                                        style: GoogleFonts.lexend(
                                          fontSize: width * 0.03,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),),
                                      ],),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              SizedBox(
                                width: width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total",
                                      style: GoogleFonts.lexend(
                                        fontSize: width * 0.03,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    FutureBuilder<int>(
                                      future: getTagihan(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Error: ${snapshot.error}',
                                            style: TextStyle(color: Colors.red),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data != null ? 'Rp. ${snapshot.data}' : 'No data available',
                                            style: GoogleFonts.lexend(
                                              fontSize: width * 0.06,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                      Container(
                        height: height * 0.6,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.indigo[50],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                                height: height * 0.05,
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Overview",
                                style: GoogleFonts.lexend(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.w500,
                                  // color: Colors.black,
                                ),
                                ),
                                Image.asset("images/notification.png",
                                height: height * 0.03,
                                width: width * 0.1,
                                ),
                              ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            SizedBox(
                              height: height * 0.2,
                              width: width * 0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: 
                                          (context) => PaymentScreen(),));
                                        },
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                          child: Container(
                                            height: height * 0.08,
                                            width: width * 0.18,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                              "images/bill1.png",
                                              height: height * 0.04,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: 
                                          (context) => MapPage(),));
                                        },
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                         child: Container(
                                            height: height * 0.08,
                                            width: width * 0.18,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                              "images/all1.png",
                                              height: height * 0.04,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: 
                                          (context) => ProfileScreen(),));
                                        },
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                          child: Container(
                                            height: height * 0.08,
                                            width: width * 0.18,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                              "images/userbiru.png",
                                              height: height * 0.04,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: 
                                          (context) => GoogleMapPage(),));
                                        },
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                          child: Container(
                                            height: height * 0.08,
                                            width: width * 0.18,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                              "images/placeholder1.png",
                                              height: height * 0.04,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: 
                                          (context) => AboutUsPage(),));
                                        },
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                          child: Container(
                                            height: height * 0.08,
                                            width: width * 0.18,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                              "images/information.png",
                                              height: height * 0.04,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: user.email == 'admin@gmail.com' ? 1.0 : 0.0,
                                        child: InkWell(
                                          onTap: (){
                                            if (user.email == 'admin@gmail.com') {
                                              Navigator.push(context, MaterialPageRoute(builder: 
                                              (context) => CrudTagihan(),));
                                            }
                                          },
                                          child: Card(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                            child: Container(
                                              height: height * 0.08,
                                              width: width * 0.18,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  "images/user-gear.png",
                                                  height: height * 0.04,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            );
          }
        },
      ),
    );
  }
}