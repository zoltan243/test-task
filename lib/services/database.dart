import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:test_task/models/user.dart';

class DatabaseHandler
{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Stream<QuerySnapshot<Object?>> get users => userCollection.snapshots();

  Future updateUserData(SimpleUser user) async
  {
    return await userCollection.doc(user.uid).set({
        'name': user.name,
        'email': user.email,
        'avatar':user.avatar
      });
  }

}
