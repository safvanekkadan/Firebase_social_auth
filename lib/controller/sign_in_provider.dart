
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth/contans/string.dart';
import 'package:firebase_social_auth/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_login/twitter_login.dart';

class  SignInProvider extends ChangeNotifier{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final twitterlogin= TwitterLogin(
    apiKey: Config.apikeytwitter, 
    apiSecretKey: Config.secretkeytwiter, 
    redirectURI: "socialauth://"
    );

  final RoundedLoadingButtonController googleController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController twitterController =RoundedLoadingButtonController();
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
      set imageUrl(String? value) {
    if (value != null) {
      _imageUrl = value;
      notifyListeners();
    }
  }
  set name(String? newName){
     name = newName;
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

  //sign in Twitter
  Future SignInWithTwitter()async{
  final authResult = await twitterlogin.loginV2();
  if(authResult.status==TwitterLoginStatus.loggedIn){
    try{
      final credential =TwitterAuthProvider.credential(
        accessToken: authResult.authToken!, 
        secret: authResult.authTokenSecret!); 
        await firebaseAuth.signInWithCredential(credential);
        final userDetails =authResult.user;
        //save
        _name =userDetails!.name;
        _email=firebaseAuth.currentUser!.email;
        _imageUrl=userDetails.thumbnailImage;
        _uid=userDetails.id.toString();
        _provider="TWITTER";
        _hasError=false;
        notifyListeners();
    }on FirebaseAuthException catch (e) {
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
  }else{
    _hasError=true;
    notifyListeners();
  }
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
  //  // ENTRY FOR CLOUDFIRESTORE
  // Future getUserDataFromFirestore(uid) async {
  //     await FirebaseFirestore.instance
  //       .collection("users").doc(uid).get().then((DocumentSnapshot snapshot) => {
  //       _uid = snapshot['uid'],
  //       _name = snapshot['name'],
  //       _email = snapshot['email'],
  //       _imageUrl = snapshot['image_url'],
  //       _provider = snapshot['provider'],

  //       }
  //     );
  //   } 
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
  
    Future<UserModel> getUserFromFirestore(uid) async {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel.fromJson(data);
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


}


