import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestFirestore extends StatefulWidget {
  const TestFirestore({super.key});

  @override
  State<TestFirestore> createState() => _TestFirestoreState();
}

class _TestFirestoreState extends State<TestFirestore> {
  var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: db.collection('users').snapshots(), 
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
          }
          //OLAH DATA
          var _data = snapshots.data!.docs;
          return ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index){
              return ListTile(
                onLongPress: (){
                  _data[index].reference.delete().then((value) => 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Data Removed"))));
                },
                title: Text(_data[index].data()['first'] +" "+ _data[index].data()['last']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final user = <String, dynamic>{
            "first": "Mirza",
            "last": "Winanda",
            "tagihan": 1000000
          };
          db.collection("users").add(user).then((DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}'));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}