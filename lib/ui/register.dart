import 'package:flutter/material.dart';

import 'package:test_task/services/authentication/auth.dart';
import 'package:test_task/services/connectivity.dart';
import 'package:test_task/ui/splash.dart';

// simple register screen to sign up using email and password

class Register extends StatefulWidget
{
  const Register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>
{
  final _formKey = GlobalKey<FormState>();

  String username = "";
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  _nameInputField(),
                  _emailInputField(),
                  _passwordInputField(),
                  const SizedBox(height: 20.0),
                  _registerButton()
                ])
              )
            )],
        )
      ),
    );
  }

  TextFormField _nameInputField()
  {
    return TextFormField(
      onChanged: (value) => setState(() => username = value),
      validator: (value) {
        if (value!.length < 6){
          return "Name too short";
        }
        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)){
          return "Name can only contain alphabetic characters";
        }
        return null;
      },
      decoration: const InputDecoration(hintText: "Name")
    );
  }

  TextFormField _emailInputField()
  {
    return TextFormField(
      onChanged: (value) => setState(() => email = value),
      validator: (value) => value!.isEmpty ? "Enter an email" : null,
      decoration: const InputDecoration(hintText: "Email")
    );
  }

  TextFormField _passwordInputField()
  {
    return TextFormField(
      obscureText: true,
      onChanged: (value) => setState(() => password = value),
      validator: (value) => value!.length < 6 ? "Enter at least 6 characters" : null,
      decoration: const InputDecoration(hintText: "Password")
    );
  }

  TextButton _registerButton()
  {
    return TextButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]!),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
      ),
      icon: const Icon(Icons.mail),
      label: const Text("Sign up"),
      onPressed: () => _onRegisterPressed()
    );
  }

  void _onRegisterPressed() async
  {
    bool isConnected = await InternetConnectivity.instance.isCurrentlyConnected();
    if (isConnected){
      if (_formKey.currentState!.validate()){
        EmailPasswordAuthentication auth = EmailPasswordAuthentication(email, password);
        auth.username = username;
        String result = await auth.register();
        if (result.isEmpty){
          Navigator.of(context).pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User registered in database"), duration: Duration(seconds: 10)));
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result), duration: const Duration(seconds: 10)));
        }                    
      }
    }
    else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Splash()));
    }
  }

}
