
import 'package:firebase_social_auth/controller/sign_in_provider.dart';
import 'package:firebase_social_auth/helpers/colors.dart';
import 'package:firebase_social_auth/view/LoginScreen/loginscreen.dart';
import 'package:firebase_social_auth/view/homescreen/widgets/imageupdate.dart';
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
           Stack(
           children: [
           Row(mainAxisAlignment: MainAxisAlignment.center,
             children: [
               CircleAvatar(
                backgroundColor: cWhiteColor,
                backgroundImage: NetworkImage("${value.imageUrl}"),
                radius: 50,
                ),
                 IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context) => ImageUpdate()));
                 }, 
                icon:Icon(Icons.image)),
             ],
           ),
   
            ],
             ),
            const SizedBox(
              height: 20,
            ),
            Stack(
           children: [
            Text(
             "Welcome ${value.name}",
             style: const TextStyle(
             fontSize: 15,
              fontWeight: FontWeight.w500,
               color: cWhiteColor,
                 ),
                ),
   
             ],
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
// void editImage() async {
//   final value = context.read<SignInProvider>();
//   final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (pickedImage != null) {
//     final imageFile = File(pickedImage.path);

//     // Upload the image to Firebase Storage
//     final storageReference = FirebaseStorage.instance.ref('profile_Pic/${value.uid}');
//     final uploadTask = storageReference.putFile(imageFile);

//     await uploadTask.whenComplete(() async {
//       final _imageUrl = await storageReference.getDownloadURL();

//       // Update the user's image URL in Firebase Realtime Database
//       final databaseReference = FirebaseDatabase.instance.ref('users/${value.uid}');
//       await databaseReference.update({'image_url': _imageUrl});

//       // Update the local state with the new image URL
      
//       value.imageUrl = _imageUrl;
      
//     });
//   }
// }
// void editName() async{
//   final value = context.read<SignInProvider>();
//   final newName = await showDialog<String>(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text('Edit Name'),
//       content: TextField(
//        // initialValue: value.name,
//         decoration: const InputDecoration(
//           labelText: 'Enter your new name',
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context, null),
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             final newName = Navigator.pop(context);
//             if (value.name != null) {
//               // Update the user's name in Firebase Realtime Database
//               final databaseReference = FirebaseDatabase.instance.ref('users/${value.uid}');
//               databaseReference.update({'name':value.name});

//               // Update the local state with the new name
              
//                 value.name =value.name;
            
//             }
//           },
//           child: const Text('Update'),
//         ),
//       ],
//     ),
//   );
// }

}



