import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../local_service.dart';

abstract class AuthenticationRepository {
  Future<dynamic> signInWithGoogle();
  Future<void> logout();
}

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  @override
  Future<dynamic> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _signInWithGoogle();
      if (googleSignInAccount == null) {
        throw SignInCanceled();
      }
      GoogleSignInAuthentication? googleAuth =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print('UserCredential: ${userCredential.user?.displayName}');
      //Get IdToken from Firebase and push to BE by api Login
      User? user = FirebaseAuth.instance.currentUser;
      // String? token = await user?.getIdToken(true);
      if (user != null) {
        GetIt.instance.get<LocalService>().setUser(user.displayName.toString());
        GetIt.instance.get<LocalService>().setAvatar(user.photoURL.toString());
      }
      return userCredential;
    } catch (e) {
      print("Error: $e");
      return e;
    }
  }

  Future<GoogleSignInAccount?> _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      return googleSignInAccount;
    } catch (error) {
      print('xxxxxxErrror : $error');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut();
      } else {
        print('Error Logout: User null');
      }
    } catch (e) {
      print('Error Logout: $e');
    }
  }
}

class SignInCanceled implements Exception {}
