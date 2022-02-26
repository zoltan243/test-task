part of auth_handler;

// handling facebook authentication

class FacebookAuthentication extends AuthenticationHandler
{
  final FacebookLogin _facebookLogin = FacebookLogin();

  @override
  Future signIn() async
  {
    try{
      final result = await _facebookLogin.logIn(permissions: [FacebookPermission.publicProfile, FacebookPermission.email]);
      if (result.status == FacebookLoginStatus.success){
        OAuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.token);
        await _firebaseAuth.signInWithCredential(facebookCredential);
        String? email = await _facebookLogin.getUserEmail();
        final userProfile = await _facebookLogin.getUserProfile();
        String? userProfilePic = await _facebookLogin.getProfileImageUrl(width: 100);
        String? name = userProfile!.name;
        _databaseHandler.updateUserData(SimpleUser(result.accessToken!.userId, email!, name!, userProfilePic ?? _defaultPhoto));
        return "";
      }
      else{
        return result.error.toString();
      }
    } on FirebaseAuthException catch(e){
      return e.message;
    } catch(e){
      return e.toString();
    }
  }

  @override
  Future signOut() async
  {
    try {
      await _firebaseAuth.signOut();

      bool isLoggedIn = await _facebookLogin.isLoggedIn;
      if (isLoggedIn) {
        await _facebookLogin.logOut();
      }
      return "";
    } catch (e) {
      return e.toString();
    }
  }
}