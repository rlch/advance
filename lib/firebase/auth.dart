import 'package:advance/firebase/remote_config.dart';
import 'package:advance/firebase/user_service.dart';
import 'package:advance/screens/welcome/get_started.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> checkAuthStatus() async {
  return await _auth.currentUser();
}

Future<FirebaseUser> signInWithEmail(String email, String password) async {
  return (await _auth.signInWithEmailAndPassword(
          email: email, password: password))
      .user;
}

Future<FirebaseUser> signUpWithEmail(String email, String password,
    SignUpDetails signUpDetails, RemoteConfigSetup remoteConfigSetup) async {
  final user = (await _auth.createUserWithEmailAndPassword(
          email: email, password: password))
      .user;
  await UserService().createUser(user, signUpDetails, remoteConfigSetup);
  return user;
}

Future<void> signOut() async {
  return FirebaseAuth.instance.signOut();
}
