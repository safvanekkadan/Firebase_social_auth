import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth/contans/string.dart';
import 'package:firebase_social_auth/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthService {
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final TwitterLogin twitterLogin = TwitterLogin(
    apiKey: Config.apikeytwitter,
    apiSecretKey: Config.secretkeytwiter,
    redirectURI: "socialauth://",
  );

    bool _isSignedIn =false;
  bool get isSignedIn=> _isSignedIn;

  // Future<User?> signInWithGoogle() async {
    
  //   // Implementation for Google Sign-In
  // }

  // Future<User?> signInWithTwitter() async {
  //   // Implementation for Twitter Sign-In
  // }

  Future userSignOut() async {
     _firebaseAuth.signOut;
   googleSignIn.signOut();
    _isSignedIn = false;
    // clear all storage information
    clearStoredData();
  }
    Future clearStoredData() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.clear();
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
