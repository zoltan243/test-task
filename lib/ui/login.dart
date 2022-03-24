import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import 'package:test_task/services/authentication/auth.dart';
import 'package:test_task/services/connectivity.dart';
import 'package:test_task/ui/register.dart';
import 'package:test_task/ui/splash.dart';
import 'package:test_task/ui/home.dart';


// login screen which gives the oppotunity to sign in with google and facebook accouns and pre-registered email/password

class Login extends StatefulWidget
{
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
{
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";

  bool _isSignInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isSignInProgress) ...[
            const Center(child: CircularProgressIndicator())
          ]
          else ...[
            _emailLoginWidget(),
            const SizedBox(height: 40.0),
            _googleLoginButton(),
            const SizedBox(height: 20.0),
            _facebookLoginButton(),
            const SizedBox(height: 20.0),
            _registerButton(),
          ],
        ],
      )),
    );
  }
  
  SignInButton _googleLoginButton()
  {
    return SignInButton(Buttons.Google,
    onPressed: () async {
      bool isConnected = await InternetConnectivity.instance.isCurrentlyConnected();
      if (isConnected){
        GoogleAuthentication auth = GoogleAuthentication();
        await _authenticate(auth);
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Splash()));
      }
    });
  }

  SignInButton _facebookLoginButton()
  {
    return SignInButton(Buttons.Facebook,
    onPressed: () async {
      bool isConnected = await InternetConnectivity.instance.isCurrentlyConnected();
      if (isConnected){
        FacebookAuthentication auth = FacebookAuthentication();
        _authenticate(auth);
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Splash()));
      }
    });
  }

  SignInButton _registerButton()
  {
    return SignInButton(Buttons.Email,
    text: "Register with Email",
    onPressed: () => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Register())));
  }

  Container _emailLoginWidget()
  {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
      child: Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            initialValue: _email,
            onChanged: (value) => setState(() => _email = value),
            validator: (value) => value!.isEmpty ? "Enter an email" : null,
            decoration: const InputDecoration(hintText: "Email")
          ),
          TextFormField(
            obscureText: true,
            onChanged: (value) => setState(() => _password = value),
            validator: (value) => value!.length < 6 ? "Enter at least 6 characters" : null,
            decoration: const InputDecoration(hintText: "Password")
          ),
          const SizedBox(height: 20.0),
          TextButton.icon(
            style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]!),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
            icon: const Icon(Icons.mail),
            label: const Text("Sign in"),
            onPressed: () async {
              if (_formKey.currentState!.validate()){
                EmailPasswordAuthentication auth = EmailPasswordAuthentication(_email, _password);
                await _authenticate(auth);                   
              }
            })]
        )
      )
    );
  }

  Future _authenticate(AuthenticationHandler auth) async
  {
    setState(() => _isSignInProgress = true);
    String? result = await auth.signIn();
    setState(() => _isSignInProgress = false);
    
    if (result == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong. Sing in failed"), duration: Duration(seconds: 10)));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
      return;
    }

    if (result.isEmpty){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(authHandler: auth)));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result), duration: const Duration(seconds: 10)));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
    }
  }

}