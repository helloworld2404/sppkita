import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba_spp/services/database.dart';
import 'package:coba_spp/tambah_tagihan.dart';
import 'package:flutter/material.dart';

class CrudTagihan extends StatefulWidget {
  const CrudTagihan({super.key});

  @override
  State<CrudTagihan> createState() => _CrudTagihanState();
}

class _CrudTagihanState extends State<CrudTagihan> {
  TextEditingController idcontroller = new TextEditingController();
  TextEditingController namasiswacontroller = new TextEditingController();
  TextEditingController keterangancontroller = new TextEditingController();
  TextEditingController tagihancontroller = new TextEditingController();
  TextEditingController statuscontroller = new TextEditingController();

  static List<String> status = <String>['Belum Lunas', 'Lunas'];
  String dropdownValue = status.first;

  var height, width;

  Stream? TagihanStream;

  getontheload()async{
    TagihanStream= await DatabaseMethod().getTagihanDetails();
    setState(() {
      
    });
  }
  @override
  void initState() {
    getontheload();
    super.initState();
  }

  PreferredSizeWidget topBar(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0, // Remove elevation
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 24.0,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "images/notification.png",
            height: height * 0.03,
            width: width * 0.1,
          ),
        ),
      ],
      toolbarHeight: kToolbarHeight + MediaQuery.of(context).padding.top,
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(String userId) async {
  if (userId.isNotEmpty) {
    try {
      return await FirebaseFirestore.instance.collection('users').doc(userId).get();
    } catch (e) {
      print("Error fetching user details: $e");
      return Future.error("Error fetching user details");
    }
  } else {
    print("Invalid userId: $userId");
    return Future.error("Invalid userId");
  }
}

  Widget allTagihanDetails(){
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  return StreamBuilder(
    stream: TagihanStream,
    builder: (context, AsyncSnapshot snapshot){
      return snapshot.hasData ? ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context, index){
          DocumentSnapshot ds = snapshot.data.docs[index];
          return FutureBuilder(
            future: getUserDetails(ds["Id_siswa"]), // Fetch user details
            builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (userSnapshot.hasError) {
                return Text('Error: ${userSnapshot.error}');
              }

              var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
              String userName = '${userData?['first']} ${userData?['last']}';

              return Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Keterangan: " + ds["Keterangan"],
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: (){
                                idcontroller.text=ds["Id_siswa"];
                                keterangancontroller.text=ds["Keterangan"];
                                statuscontroller.text=ds["Status"];
                                tagihancontroller.text=ds["Tagihan"];

                                EditTagihanDetail(ds["Id_tagihan"]);
                              },
                              child: Icon(Icons.edit, color: Color(0xFF241BCC),)),
                            SizedBox(width: 5.0,),
                            GestureDetector(
                              onTap: () async{
                                await DatabaseMethod().deleteTagihanDetail(ds["Id_tagihan"]);
                              },
                              child: Icon(Icons.delete, color: Colors.red,)),
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Tagihan: ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ds["Tagihan"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Status: ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ds["Status"],
                              style: TextStyle(
                                color: ds["Status"] == "Lunas" ? Colors.green : Colors.red,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Siswa Name: ", // Changed to show Siswa's name
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: userName, // Use the user's name fetched from 'users' collection
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.normal,
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
            },
          );
        },
      ) : Container();
    }
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>TambahTagihan()));
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0,),
        child: Column(
          children: [
            Expanded(child: allTagihanDetails(),),
          ],
        ),
      ),
    );
  }
  Future EditTagihanDetail(String id) async {
  // Retrieve existing data for the tagihan detail using its ID
  Map<String, dynamic> tagihanDetailData = (await DatabaseMethod().getTagihanDetailById(id)) ?? {};

  // Set the dropdown value to the existing status value
  String dropdownValue = tagihanDetailData["Status"] ?? "Belum Lunas";

  // Fetch user details based on the ID
  DocumentSnapshot userSnapshot = await getUserDetails(tagihanDetailData["Id_siswa"]);

  // Extract user data
  Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

  // Check if userData is not null before accessing its values
  if (userData != null) {
    // Combine first and last name
    String userName = '${userData['first']} ${userData['last']}';

    // Populate namasiswacontroller with the student's name
    namasiswacontroller.text = userName;
  } else {
    // Handle the case where userData is null
    // For example, you can set a default value for namasiswacontroller
    namasiswacontroller.text = 'Unknown';
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.cancel),
                ),
              ],
            ),
            SizedBox(height: 25.0,),
            Text("ID Siswa", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.only(left: 10.0,),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: idcontroller,
                enabled: false,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(height: 20.0,),
            Text("Nama Siswa", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.only(left: 10.0,),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: namasiswacontroller,
                enabled: false,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(height: 20.0,),
            Text("Keterangan", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.only(left: 10.0,),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: keterangancontroller,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(height: 20.0,),
            Text("Tagihan", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.only(left: 10.0,),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: tagihancontroller,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(height: 20.0,),
            Text("Status", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 10.0,),
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
            SizedBox(height: 30.0,),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> updateInfo = {
                    "Id_siswa": idcontroller.text,
                    "Id_tagihan": id,
                    "Keterangan": keterangancontroller.text,
                    "Tagihan": tagihancontroller.text,
                    "Status": dropdownValue,
                  };
                  await DatabaseMethod().updateTagihanDetail(id, updateInfo).then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Text("Update"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}