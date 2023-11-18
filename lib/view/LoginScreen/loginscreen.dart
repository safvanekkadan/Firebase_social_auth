import 'package:firebase_social_auth/controller/internet_provider.dart';
import 'package:firebase_social_auth/controller/sign_in_provider.dart';
import 'package:firebase_social_auth/helpers/colors.dart';
import 'package:firebase_social_auth/view/homescreen/home.dart';
import 'package:firebase_social_auth/view/widgets/next_screen.dart';
import 'package:firebase_social_auth/view/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor:Colors.black,
        title: const Text(
          "Auth App",
          style: TextStyle(
            color:Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body:Consumer<SignInProvider>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundedLoadingButton(
                onPressed: () {
                  handleGoogleSignIn(context);
                },
                controller: value.googleController,
                successColor: cBlackColor,
                width: MediaQuery.of(context).size.width * 0.80,
                elevation: 0,
                borderRadius: 25,
                color: cWhiteColor,
                child: Wrap(
                  children: [
                    Image.network("https://w7.pngwing.com/pngs/223/537/png-transparent-padlock-key-self-storage-security-clean-coal-text-rectangle-logo-thumbnail.png", height: 25),
                   const  SizedBox(width: 5,),
                    const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        color: cBlackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // RoundedLoadingButton(
              //   onPressed: () {},
              //   controller: value.facebookController,
              //   successColor: cDarkBlueColor,
              //   width: MediaQuery.of(context).size.width * 0.80,
              //   elevation: 0,
              //   borderRadius: 25,
              //   color: cDarkBlueColor,
              //   child:  const Wrap(
              //     children: [
              //        Icon(
              //         FontAwesomeIcons.facebook,
              //         size: 20,
              //         color: cWhiteColor,
              //       ),
              //      SizedBox(width: 15),
              //        Text(
              //         "Sign in with Facebook",
              //         style: TextStyle(
              //           color: cWhiteColor,
              //           fontSize: 15,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 30),
              // RoundedLoadingButton(
              //   onPressed: () {
              //   //  value.signInWithGitHub();
              //   },
              //   controller: value.,
              //   successColor: cLightBlackColor,
              //   width: MediaQuery.of(context).size.width * 0.80,
              //   elevation: 0,
              //   borderRadius: 25,
              //   color: cLightBlackColor,
              //   child:  const Wrap(
              //     children: [
              //       Icon(
              //         FontAwesomeIcons.github,
              //         size: 20,
              //         color: cWhiteColor,
              //       ),
              //       SizedBox(width: 15),
              //       Text(
              //         "Sign in with Twitter",
              //         style: TextStyle(
              //           color: cWhiteColor,
              //           fontSize: 15,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          );
        },
      ) ,
    );
  }
    // HANDLING GOOGLE SIGNIN IN
  Future handleGoogleSignIn(BuildContext context) async {
    final data = context.read<SignInProvider>();
    final network = context.read<InternetProvider>();
    await network.checkInternetConnection();

    if (network.hasInternet == false) {
      // ignore: use_build_context_synchronously
      openSnackBar(context, "Check your Internet connection", cRedColor);
      data.googleController.reset();
    } else {
      await data.signInWithGoogle().then((value) {
        if (data.hasError == true) {
          openSnackBar(context, data.errorCode.toString(), cRedColor);
          data.googleController.reset();
        } else {
          // CHECKING WHETHER USER EXISTS OR NOT
          data.checkUserExists().then((value) async {
            if (value == true) {
              // USER EXISTS
              await data.getUserDataFromFirestore(data.uid).then((value) => data
                  .saveDataToSharedPreferences()
                  .then((value) => data.setSignIn().then((value) {
                        data.googleController.success();
                        handleAfterSignIn(context);
                      })));
            } else {
              // USER DOES NOT EXIST
              data.saveDataToFirestore().then((value) => data
                  .saveDataToSharedPreferences()
                  .then((value) => data.setSignIn().then((value) {
                        data.googleController.success();
                        handleAfterSignIn(context);
                      })));
            }
          });
        }
      });
    }
  }
   // HANDLE AFTER SIGNIN
  handleAfterSignIn(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const HomeScreen());
    });
  }
}
