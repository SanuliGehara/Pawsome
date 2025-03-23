
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pawsome/reusable_widgets/reusable_widget.dart';
import 'package:pawsome/services/database_service.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  DatabaseService _databaseService = new DatabaseService();

  /// If the user already exists (if a Firestore document for the user is found),
  /// this method shows an error message prompting the user to log in instead.
  /// Otherwise, it creates a new Firestore user document and signs the user in.
  ///
  /// The [context] parameter is used to show SnackBar messages.
  Future<UserCredential?> signInWithGoogleForSignup(BuildContext context) async {
    try {
      // Trigger the Google sign-in flow.
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      // If the user cancels the sign-in, return null.
      if (googleSignInAccount == null) return null;

      // Obtain the authentication details from the request.
      final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      // Create a new credential for Firebase authentication.
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential.
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Extract user details from the Google account.
      String username = userCredential.user?.displayName ??
          googleSignInAccount.displayName ??
          "Google User";
      String email = userCredential.user?.email ?? googleSignInAccount.email;

      // Check if a user document already exists.
      bool exists = await _databaseService.doesUserExist(email);
      if (exists) {
        // If a user already exists, notify the user and prompt to log in.
        showCustomSnackBar(context, "User already exists. Please log in.", Colors.transparent);
        // sign the user out here to avoid duplicate session.
        await googleSignOut();
        return null;
      } else {
        // Create a new user document in Firestore.
        await _databaseService.createNormalUser(username, email);
        showCustomSnackBar(context, "Created Normal User account in DB", Colors.green);
        print("Created Normal User account in DB");
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Print and show error message if sign-in fails.
      print("Google Sign-In Error: ${e.message}");
      showCustomSnackBar(context, "Google Sign-In Error: ${e.message}", Colors.red);
      throw e;
    }
  }

  /// This method initiates the Google sign-in flow and simply signs the user in.
  /// It does not create a new Firestore document because it assumes the user has
  /// already signed up.
  ///
  /// The [context] parameter is used to show SnackBar messages.
  Future<UserCredential?> signInWithGoogleForLogin(BuildContext context) async {
    try {
      // Trigger the Google sign-in flow.
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) return null; // User canceled sign-in.

      // Obtain authentication details.
      final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      // Create a credential for Firebase.
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase.
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Extract user details.
      String email = userCredential.user?.email ?? googleSignInAccount.email;

      // Optionally, check if the user document exists.
      bool exists = await _databaseService.doesUserExist(email);
      if (!exists) {
        // If the user document does not exist, you might notify the user to sign up.
        showCustomSnackBar(context, "No account found. Please sign up first.", Colors.transparent);
        // Optionally sign out to clear session.
        await googleSignOut();
        return null;
      }

      // Successful login.
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Google Sign-In (Login) Error: ${e.message}");
      showCustomSnackBar(context, "Error: ${e.message}", Colors.red);
      throw e;
    }
  }


  googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
