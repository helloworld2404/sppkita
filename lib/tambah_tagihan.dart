import 'package:coba_spp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class TambahTagihan extends StatefulWidget {
  const TambahTagihan({super.key});

  @override
  State<TambahTagihan> createState() => _TambahTagihanState();
}

class _TambahTagihanState extends State<TambahTagihan> {
  TextEditingController niscontroller = TextEditingController();
  TextEditingController idcontroller = TextEditingController();
  TextEditingController keterangancontroller = TextEditingController();
  TextEditingController tagihancontroller = TextEditingController();
  TextEditingController statuscontroller = TextEditingController();
  TextEditingController namasiswacontroller = TextEditingController();

  // List<String> idSiswaList = []; // List to store ID siswa values
  // String? selectedIdSiswa; // Currently selected ID siswa

  List<String> nisSiswaList = []; // List to store ID siswa values
  String? selectedNisSiswa; // Currently selected ID siswa

  @override
  void initState() {
    super.initState();
    //getIdSiswaList();
    getNisSiswaList(); // Fetch ID siswa values when the widget initializes
  }
  

  // void getIdSiswaList() async {
  //   // Fetch data from the database using DatabaseMethod
  //   List<String> fetchedIdSiswaList = await DatabaseMethod().getIdSiswaList();
  //   setState(() {
  //     idSiswaList = fetchedIdSiswaList;
  //   });
  // }
  void getNisSiswaList() async {
    // Fetch data from the database using DatabaseMethod
    List<String> fetchedNisSiswaList = await DatabaseMethod().getNisSiswaList();
    setState(() {
      nisSiswaList = fetchedNisSiswaList;
    });
  }
  

  static List<String> status = <String>['Belum Lunas', 'Lunas'];
  String dropdownValue = status.first;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
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
                        color: Colors.black,
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
                child: Column(children: [
                  Text(
                    'TAMBAH TAGIHAN',
                    style: TextStyle(fontSize: 24.0, color: Colors.black),
                  )
                ],),
              ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nis Siswa",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0, // Adjusted font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                    child: DropdownButtonFormField(
                      value: selectedNisSiswa,
                      items: nisSiswaList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) async {
                        setState(() {
                          selectedNisSiswa = newValue;
                        });
                        if (newValue != null) {
                          // Fetch data for the selected NIS siswa
                          String? userId = await DatabaseMethod().getUserIdByNis(newValue);
                          if (userId != null) {
                            // Fetch user details using the retrieved user ID
                            Map<String, dynamic>? userDetails = await DatabaseMethod().getUserDetails(userId);
                            if (userDetails != null) {
                              // Populate the "Nama Siswa" and "ID Siswa" fields with the fetched data
                              setState(() {
                                idcontroller.text = userId;
                                // Assuming "first" and "last" are fields in the users collection
                                String namaSiswa = userDetails['first'] + " " + userDetails['last'];
                                // Update the "Nama Siswa" text field
                                // (You need to replace TextField with TextFormField to enable text editing)
                                namasiswacontroller.text = namaSiswa;
                              });
                            }
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Nama Siswa",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0, // Adjusted font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0), // Adjusted height
                  SizedBox(
                    height: height * 0.05, // Adjusted height
                    child: TextFormField(
                      controller: namasiswacontroller,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Enter Nama Siswa',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "ID Siswa",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0, // Adjusted font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0), // Adjusted height
                  SizedBox(
                    height: height * 0.05, // Adjusted height
                    child: TextFormField(
                      controller: idcontroller,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Enter ID Siswa',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Keterangan",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0, // Adjusted font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0), // Adjusted height
                  SizedBox(
                    height: height * 0.05, // Adjusted height
                    child: TextField(
                      controller: keterangancontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Enter Keterangan',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Tagihan",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0, // Adjusted font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0), // Adjusted height
                  SizedBox(
                    height: height * 0.05, // Adjusted height
                    child: TextField(
                      controller: tagihancontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Enter Tagihan',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Status",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0, // Adjusted font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0), // Adjusted height
                  SizedBox(
                    height: height * 0.05, // Adjusted height
                    child: DropdownButtonFormField(
                      value: dropdownValue,
                      items: status.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Check if any of the text fields are empty
                        if (selectedNisSiswa == null ||
                            keterangancontroller.text.isEmpty ||
                            tagihancontroller.text.isEmpty) {
                          // Show a toast message if any field is empty
                          Fluttertoast.showToast(
                            msg: "Mohon isi setiap field dengan benar",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return; // Exit the function if any field is empty
                        }

                        // Proceed with adding data to Firestore
                        String Id = randomAlphaNumeric(10);
                        Map<String, dynamic> tagihanInfoMap = {
                          "Id_tagihan": Id,
                          "Id_siswa": idcontroller.text,
                          "Keterangan": keterangancontroller.text,
                          "Tagihan": tagihancontroller.text,
                          "Status": dropdownValue,
                        };
                        await DatabaseMethod()
                            .addTagihanDetails(tagihanInfoMap, Id)
                            .then((value) {
                          // Reset text controllers and selected values
                          idcontroller.clear();
                          keterangancontroller.clear();
                          tagihancontroller.clear();
                          namasiswacontroller.clear();
                          setState(() {
                            dropdownValue = status.first;
                            selectedNisSiswa = null;
                          });
                          Fluttertoast.showToast(
                            msg: "Tagihan baru berhasil ditambahkan!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        });
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Adjusted font size
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
