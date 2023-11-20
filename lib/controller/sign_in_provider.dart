import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class  SignInProvider extends ChangeNotifier{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final RoundedLoadingButtonController googleController = RoundedLoadingButtonController();

  bool _isSignedIn =false;
  bool get isSignedIn=> _isSignedIn;
   //hasError, errorCode, provider,uid, email, name, imageUrl
  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;
  
  SignInProvider(){
    checkSignInUser();
  }
  void checkSignInUser()async {
    final SharedPreferences s=await SharedPreferences.getInstance();
    _isSignedIn =s.getBool("signed_in")??false;
    notifyListeners();
}
  Future setSignIn() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // executing our authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // signing to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        // now save all values
        _name = userDetails.displayName;
        _email = userDetails.email;
        _imageUrl = userDetails.photoURL;
        _provider = "Google";
        _uid = userDetails.uid;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }
   // ENTRY FOR CLOUDFIRESTORE
  Future getUserDataFromFirestore(uid) async {
      await FirebaseFirestore.instance
        .collection("users").doc(uid).get().then((DocumentSnapshot snapshot) => {
        _uid = snapshot['uid'],
        _name = snapshot['name'],
        _email = snapshot['email'],
        _imageUrl = snapshot['image_url'],
        _provider = snapshot['provider'],

        }
      );
    } 
    Future saveDataToFirestore() async {
     final DocumentReference r =FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "uid": _uid,
      "image_url": _imageUrl,
      "provider": _provider,
    });
    notifyListeners();
  }

 Future saveDataToSharedPreferences() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString('name', _name!);
    await sharedPref.setString('email', _email!);
    await sharedPref.setString('uid', _uid!);
    await sharedPref.setString('image_url', _imageUrl!);
    await sharedPref.setString('provider', _provider!);
    notifyListeners();
  }
    Future getDataFromSharedPreferences() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    _name = sharedPref.getString('name');
    _email = sharedPref.getString('email');
    _imageUrl = sharedPref.getString('image_url');
    _uid = sharedPref.getString('uid');
    _provider = sharedPref.getString('provider');
    notifyListeners();
  }
    // checkUser exists or not in cloudfirestore
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      print("EXISTING USER");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }
    // signout
  Future userSignOut() async {
    await firebaseAuth.signOut;
    await googleSignIn.signOut();
   

    _isSignedIn = false;
    notifyListeners();
    // clear all storage information
    clearStoredData();
  }

  Future clearStoredData() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.clear();
  }
  Future<UserCredential> signInWithGoogle2() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
}


