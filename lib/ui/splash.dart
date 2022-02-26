import 'package:flutter/material.dart';

import 'package:test_task/services/connectivity.dart';
import 'package:test_task/ui/login.dart';

// simple splash screen to wait for internet connection

class Splash extends StatefulWidget
{
  const Splash({ Key? key }) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>
{
  bool _isConnected = false;
  final InternetConnectivity _connectivity = InternetConnectivity.instance;

  @override
  void initState()
  {
    super.initState();
    _connectivity.initialise();
    _connectivity.stream.listen((value)
    {
      setState(() => _isConnected = value);
      if (_isConnected){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Task"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Waiting for network connection"),
            SizedBox(height: 40.0),
            CircularProgressIndicator()
          ],
        )
      )
    );
  }
}