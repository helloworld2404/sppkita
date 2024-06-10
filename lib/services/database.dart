import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  Future addTagihanDetails(Map<String, dynamic> tagihanInfoMap, String id)async{
    return await FirebaseFirestore.instance.collection("Tagihan").doc(id).set(tagihanInfoMap);
  }

  Future<Stream<QuerySnapshot>> getTagihanDetails()async{
    return FirebaseFirestore.instance.collection("Tagihan").snapshots();
  }

  Future updateTagihanDetail(String id, Map<String, dynamic>updateInfo)async{
    return FirebaseFirestore.instance.collection("Tagihan").doc(id).update(updateInfo);
  }

  Future deleteTagihanDetail(String id)async{
    return FirebaseFirestore.instance.collection("Tagihan").doc(id).delete();
  }

  Future<List<String>> getIdSiswaList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("users")
          .get();

      List<String> idSiswaList = [];

      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) {
          idSiswaList.add(doc.id);
        });
      }

      return idSiswaList;
    } catch (e) {
      // Handle errors here, e.g., log them or return an empty list
      print("Error getting ID siswa list: $e");
      return [];
    }
  }

  Future<List<String>> getNisSiswaList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("users")
          .get();

      List<String> nisSiswaList = [];

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        nisSiswaList.add(data['nis']);
      }
    }

      return nisSiswaList;
    } catch (e) {
      // Handle errors here, e.g., log them or return an empty list
      print("Error getting ID siswa list: $e");
      return [];
    }
  }

  Future<String?> getUserIdByNis(String nis) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("nis", isEqualTo: nis)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Return the user ID if a user with the given NIS is found
        return snapshot.docs.first.id;
      } else {
        // Return null if no user with the given NIS is found
        return null;
      }
    } catch (e) {
      // Handle errors here, e.g., log them or return null
      print("Error getting user ID by NIS: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (snapshot.exists) {
        // Return the data if the document exists
        return snapshot.data();
      } else {
        // Return null if the document does not exist
        return null;
      }
    } catch (e) {
      // Handle errors here, e.g., log them or return null
      print("Error getting user details by ID: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTagihanDetailById(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("Tagihan")
          .doc(id)
          .get();

      if (snapshot.exists) {
        // Return the data if the document exists
        return snapshot.data();
      } else {
        // Return null if the document does not exist
        return null;
      }
    } catch (e) {
      // Handle errors here, e.g., log them or return null
      print("Error getting tagihan detail by ID: $e");
      return null;
    }
  }

}