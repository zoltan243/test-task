part of auth_handler;

// handling google authentication

class GoogleAuthentication extends AuthenticationHandler
{
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Future signIn() async
  {
    try{
      GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
      if (googleAccount != null)
      {
        GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
        OAuthCredential googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
        );
        await _firebaseAuth.signInWithCredential(googleCredential);
        await _databaseHandler.updateUserData(
          SimpleUser(googleAccount.id, googleAccount.email,
          googleAccount.displayName ?? googleAccount.email,
          googleAccount.photoUrl??_defaultPhoto)
        );
        return "";
      }
      else{
        return "Login failed";
      }
    } on FirebaseAuthException catch(e){
      return e.message;
    } catch(e){
      return e.toString();
    }
  }

  @override
  Future signOut() async {
    try {
      await _firebaseAuth.signOut();

      bool isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        await _googleSignIn.signOut();
      }
      return "";
    } catch (e) {
      return e.toString();
    }
  }
}