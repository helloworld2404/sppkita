import 'dart:convert';

import 'package:coba_spp/custom_paint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  List _listdata=[];
  Future _getdata() async{
    try {
      final response = await http.get(
        Uri.parse('http://192.168.100.41/flutterapi/sppkita/read.php'));
        if (response.statusCode==200) {
          //print(response.body);
          final data = jsonDecode(response.body);
          setState(() {
            _listdata=data;
          });
        }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getdata();
    super.initState();
  }

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
              Center(
                child: Image.asset(
                  "images/harvard.png",
                  height: height * 0.4,
                  width: width * 0.6,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _listdata.isNotEmpty ? _listdata[0]['first_text'] ?? '' : '',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      _listdata.isNotEmpty ? _listdata[0]['second_text'] ?? '' : '',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      _listdata.isNotEmpty ? _listdata[0]['address'] ?? '' : '',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      _listdata.isNotEmpty ? _listdata[0]['phone'] ?? '' : '',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
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
