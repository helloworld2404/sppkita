import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba_spp/custom_paint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'home_screen.dart';
import 'services/api_service.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Uri _url = Uri.parse('https://app.sandbox.midtrans.com/payment-links/1710235906634');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser!;

    Future<int> getTagihan() async {
      var userId = user.uid;
      var apiService = ApiService(baseUrl: 'http://10.0.2.2:8000/api');
      var pembayaranData = await apiService.fetchTotalPembayaran(userId);
      
      // Initialize total tagihan
      num totalTagihan = 0;

      // Calculate total tagihan from fetched data
      pembayaranData.forEach((item) {
        totalTagihan += (item['spp']['nominal'] ?? 0).toInt();
      });

      return totalTagihan.toInt();
    }

    return Scaffold(
      backgroundColor: Color(0xFF241BCC).withOpacity(0.9),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: CustomPaint(
          painter: Painter(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        Navigator.push(context, MaterialPageRoute(builder: 
                                          (context) => HomeScreen(),));
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
              SizedBox(height: height * 0.25),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Total Amount:',
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
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
                            'RP. ${snapshot.data}',
                            style: TextStyle(
                              fontSize: width * 0.06,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Payment?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Update the tagihan status to "Lunas"
                                    var userId = FirebaseAuth.instance.currentUser!.uid;
                                    var apiService = ApiService(baseUrl: 'http://10.0.2.2:8000/api');
                                    var pembayaranData = await apiService.fetchTotalPembayaran(userId);
                                    
                                    pembayaranData.forEach((item) async {
                                      if (item['status'] != "Lunas") {
                                        await apiService.updateTagihanStatus(item['id'].toString());
                                      }
                                    });

                                    Navigator.of(context).pop(); // Close the dialog
                                    Navigator.push(context, MaterialPageRoute(builder: 
                                          (context) => HomeScreen(),)); // Go back to the previous screen
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 17, 9, 168), // Use the specified color for the button
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 15,
                      ),
                      child: Text(
                        'Make Payment',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
