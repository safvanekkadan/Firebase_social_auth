import 'dart:async';

import 'package:firebase_social_auth/controller/sign_in_provider.dart';
import 'package:firebase_social_auth/view/homescreen/home.dart';
import 'package:firebase_social_auth/view/LoginScreen/loginscreen.dart';
import 'package:firebase_social_auth/view/widgets/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final shrdprfncre = context.read<SignInProvider>();
    super.initState();
    Timer(const Duration(seconds: 6), () {
      shrdprfncre.isSignedIn == false
          ? nextScreen(context, const LoginScreen())
          : nextScreen(context, const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body: SafeArea(
        child: Center(
          child: Image.network(
            "https://w7.pngwing.com/pngs/223/537/png-transparent-padlock-key-self-storage-security-clean-coal-text-rectangle-logo-thumbnail.png"),
        ),
      ),
    );
  }
}
