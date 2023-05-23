import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  static Future getUser(String value) async {
    String? id = await userIDLoad();
    print("database service çalıştı id: $id");
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot docSnapshot = await users.doc(id).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      if (value == "class") {
        String? userClass = data['class'];
        return userClass;
      }
      if (value == "id") {
        String? userID = data['id'];
        return userID;
      }
      if (value == "name") {
        String? userName = data['name'];
        print("if blogları çalıştı name: $userName");
        return userName;
      }
      if (value == "phone") {
        String? userPhone = data['phone'];
        return userPhone;
      }
    }
  }

  static void userIDSave(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', id);
    // Diğer işlemler
  }

  static Future<String?> userIDLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('user_id');
    return id;
  }
}
