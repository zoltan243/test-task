library auth_handler;

import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:test_task/services/database.dart';
import 'package:test_task/models/user.dart';

part 'email_auth.dart';
part 'google_auth.dart';
part 'facebook_auth.dart';

// base class for a simple authentication solution

abstract class AuthenticationHandler
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseHandler _databaseHandler = DatabaseHandler();

  final String _defaultPhoto = "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png";

  Future signIn();
  Future signOut();
}