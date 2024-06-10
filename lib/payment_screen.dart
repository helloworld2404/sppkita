import 'package:coba_spp/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/api_service.dart';
import 'tagihan_pay.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var height, width;
  late ApiService apiService;
  late Future<List<dynamic>> futurePembayaran;
  late String currentUserId;
  late int totalTagihan;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    apiService = ApiService(baseUrl: 'http://sppkita.skom.id/api');
    futurePembayaran = apiService.fetchPembayaran();
    totalTagihan = 0;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<List<dynamic>>(
          future: futurePembayaran,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("ERROR: ${snapshot.error}"),
              );
            } else {
              // Filter data where akunid == currentUserId
              final filteredData = snapshot.data!.where((item) => item['siswa']['akunid'] == currentUserId).toList();
              return Container(
                height: height,
                width: width,
                color: Colors.indigo[50],
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
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
                    SizedBox(
                      width: width * 0.9,
                      child: Text(
                        "Payment History",
                        style: GoogleFonts.lexend(
                          fontSize: width * 0.034,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.035),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final pembayaran = filteredData[index];
                          final keterangan = 'SPP ${pembayaran['bulan']}';
                          final tagihan = pembayaran['spp']['nominal'];
                          final status = (pembayaran['status'] ?? 'Belum lunas').toString().capitalize();
                          return GestureDetector(
                            onTap: () {
                              if (status == "Lunas") {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Tagihan sudah lunas"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                final tagihanAmount = pembayaran['spp']['nominal'].toString();
                                final tagihanId = pembayaran['id'].toString();
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TagihanPay(
                                    keterangan: keterangan,
                                    tagihanAmount: tagihanAmount,
                                    tagihanId: tagihanId,
                                  ),
                                ),
                              );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.01),
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: height * 0.075,
                                        width: width * 0.15,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Color(0xFF241BCC).withOpacity(0.8),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.attach_money,
                                            size: height * 0.04,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                keterangan,
                                                style: GoogleFonts.lexend(
                                                  fontSize: width * 0.035,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                "Tagihan: $tagihan",
                                                style: GoogleFonts.lexend(
                                                  fontSize: width * 0.03,
                                                  fontWeight: FontWeight.w500,
                                                  color: status == "Lunas" ? Colors.green : Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        status,
                                        style: GoogleFonts.lexend(
                                          fontSize: width * 0.035,
                                          fontWeight: FontWeight.w500,
                                          color: status == "Lunas" ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
  void computeTotalTagihan(List<dynamic> pembayaranData) {
    setState(() {
      totalTagihan = pembayaranData
          .where((item) => item['status'] != 'Lunas' && item['siswa']['akunid'] == currentUserId)
          .map<int>((item) => (item['spp']['nominal'] ?? 0) as int)
          .reduce((value, element) => value + element);
    });
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
  }
}