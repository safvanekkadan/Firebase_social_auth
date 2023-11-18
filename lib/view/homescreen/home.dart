import 'package:firebase_social_auth/controller/sign_in_provider.dart';
import 'package:firebase_social_auth/helpers/colors.dart';
import 'package:firebase_social_auth/view/LoginScreen/loginscreen.dart';
import 'package:firebase_social_auth/view/widgets/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    Future getData() async {
    final value = context.read<SignInProvider>();
    value.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    // change read to watch!!!!
    final value = context.watch<SignInProvider>();
    return Scaffold(
      backgroundColor: cBlackColor,
      appBar: AppBar(
        backgroundColor: cLightBlackColorrr,
        title: const Text(
          "Home Screen",
          style: TextStyle(
            color: cWhiteColor,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: cWhiteColor,
              backgroundImage: NetworkImage("${value.imageUrl}"),
              radius: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Welcome ${value.name}",
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: cWhiteColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${value.email}",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: cWhiteColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${value.uid}",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: cWhiteColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "PROVIDER:",
                  style: TextStyle(color: cGreyColor),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text("${value.provider}".toUpperCase(),
                    style: const TextStyle(color: cRedColor)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  value.userSignOut();
                  nextScreenReplace(context, const LoginScreen());
                },
                child: const Text("SIGNOUT",
                    style: TextStyle(
                      color: cBlackColor,
                      fontWeight: FontWeight.bold,
                     )
                   )
                  )
               ],
             ),
           ),
        );
      }
}