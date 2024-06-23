import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  Future<void> new_user(emailAddress, password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      print(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      // print(e);
    }
  }
Future<void> signin(String email, String password) async {
  try {
    UserCredential authUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
    );
    print(authUser.user?.uid);
  } catch (error) {
    print('Error: $error');
    // Handle specific error cases if necessary, e.g., network errors, incorrect password, etc.
  }
}
Future<UserCredential> signInWithGoogle() async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // The user canceled the sign-in
      print("Sign in aborted by user");
      throw Exception("Sign in aborted by user");
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (error) {
    print('Error during Google Sign-In: $error');
    rethrow; // Re-throw the error to handle it outside the function if needed
  }
}
Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      print('User signed out');
    } catch (error) {
      print('Error signing out: $error');
    }
  }
}