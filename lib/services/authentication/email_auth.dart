part of auth_handler;

// handling email and password sing up/in

class EmailPasswordAuthentication extends AuthenticationHandler
{
  String _username = "";
  final String _email;
  final String _password;

  EmailPasswordAuthentication(this._email, this._password);

  set username(String name) => _username = name;

  @override
  Future signIn() async
  {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  Future register() async
  {
    try{
      UserCredential userData = await _firebaseAuth.createUserWithEmailAndPassword(email: _email, password: _password);
      _databaseHandler.updateUserData(SimpleUser(userData.user!.uid, _email, _username, _defaultPhoto));
      return "";
    }catch(e){
      return e.toString();
    }
  }

  @override
  Future signOut() async
  {
    try {
      await _firebaseAuth.signOut();
      return "";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    catch(e){
      return e.toString();
    }
  }
}