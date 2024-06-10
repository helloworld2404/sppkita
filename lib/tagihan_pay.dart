import 'package:coba_spp/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:coba_spp/custom_paint.dart';
import 'package:coba_spp/services/api_service.dart';

class TagihanPay extends StatelessWidget {
  final String keterangan;
  final String tagihanAmount;
  final String tagihanId;

  const TagihanPay({
    required this.keterangan,
    required this.tagihanAmount,
    required this.tagihanId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                                          (context) => PaymentScreen(),));
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
                      keterangan,
                      style: TextStyle(
                        fontSize: width * 0.06,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Rp. $tagihanAmount",
                      style: TextStyle(
                        fontSize: width * 0.06,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirmation"),
                              content: Text("Are you sure you want to make this payment?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Create an instance of ApiService
                                    final apiService = ApiService(baseUrl: 'http://sppkita.skom.id/api');
                                    
                                    // Update the status to "Lunas" using the API service
                                    try {
                                      await apiService.updateTagihanStatus(tagihanId.toString());
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Payment confirmed'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      Navigator.pop(context); // Go back to the previous screen
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to update status'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                    Navigator.push(context, MaterialPageRoute(builder: 
                                          (context) => PaymentScreen(),));
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 17, 9, 168),
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
