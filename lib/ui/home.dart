import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:test_task/services/authentication/auth.dart';
import 'package:test_task/services/push_notification.dart';
import 'package:test_task/services/database.dart';
import 'package:test_task/ui/login.dart';


class Home extends StatefulWidget
{
  final AuthenticationHandler authHandler;
  const Home({ Key? key, required this.authHandler }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
{
  @override
  void initState()
  {
    super.initState();
    final pushNotification = PushNotification();
    pushNotification.initialise();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: appBarBuilder(),
      body: bodyBuilder()
    );
  }

  AppBar appBarBuilder()
  {
    return AppBar(
        title: const Text("Registered users"),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text("Sign out"),
            onPressed: () async {
              await widget.authHandler.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
            }),
        ],
      );
  }

  FutureBuilder<QuerySnapshot> bodyBuilder()
  {
    return FutureBuilder<QuerySnapshot>(
      future: DatabaseHandler().users,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
      {
        if (snapshot.hasData)
        {
          return ListView(
            padding: const EdgeInsets.all(10.0),
            children: snapshot.data?.docs.map((doc) {
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 10,
                  child: Column(children: [
                    ListTile(
                      title: Text("Name: " + doc["name"]),
                      subtitle: Text("Email: " + doc["email"]),
                      tileColor: Colors.blueGrey[800],
                      leading: CircleAvatar(
                        radius: 30.0, 
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0), 
                          child: Image.network(doc["avatar"])
                        )
                      )
                    )
                  ])
                ),
              );
            }).toList() as List<Widget>,
          );
        }
        else{
          return const Text("No Items");
        }
      },
    );
  }

}
