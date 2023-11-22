
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_social_auth/controller/sign_in_provider.dart';
import 'package:firebase_social_auth/view/homescreen/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageUpdate extends StatefulWidget {
  const ImageUpdate({super.key});

  @override
  State<ImageUpdate> createState() => _SettingsState();
}

class _SettingsState extends State<ImageUpdate> {
  Uint8List? image;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  // Future uploadFile() async {
  //   final Path = 'Profile_Pic/${pickedFile?.name}';
  //   final file = File(pickedFile!.path!);
  //   final ref = FirebaseStorage.instance.ref().child(Path);
  //   ref.putFile(file);
  //   final snapshot = await uploadTask?.whenComplete(() {});
  //   final UrlDownload = await snapshot?.ref.getDownloadURL();
  //   print('Download Link $UrlDownload');
  // }
  void editImage() async {
  final value = context.watch<SignInProvider>();
  final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    final imageFile = File(pickedImage.path);

    // Upload the image to Firebase Storage
    final storageReference = FirebaseStorage.instance.ref('profile_Pic/${value.uid}');
    final uploadTask = storageReference.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      final _imageUrl = await storageReference.getDownloadURL();

      // Update the user's image URL in Firebase Realtime Database
      final databaseReference = FirebaseDatabase.instance.ref('users/${value.uid}');
      await databaseReference.update({'image_url': _imageUrl});

      // Update the local state with the new image URL
      
      value.imageUrl = _imageUrl;
      
    });
  }
}
pickimage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('Image Not Selected');

  return <int>[];
}

  Future<void> selectImage() async {
    final result = await FilePicker.platform.pickFiles();
     Uint8List? img = await pickimage(ImageSource.gallery);
    setState(() {
      pickedFile = img as PlatformFile?;
    });
    setState(() {
      pickedFile = result?.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pickedFile != null
                ? GestureDetector(
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.amber,
                      child: Image.file(
                        File(pickedFile!.path!),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                :const  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage("https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o="),
                  ),
            Positioned(
              bottom: -5,
              left: 70,
              child: IconButton(
                onPressed: selectImage,
                icon:const  Icon(Icons.add_circle_outline),
              ),
            ),
            TextButton.icon(
                onPressed: editImage,
                icon:const  Icon(Icons.upload),
                label: const Text('Upload Profile')),
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>const  HomeScreen(),
                  ));
                },
                icon: const Icon(Icons.arrow_back_sharp),
                label:const  Text(' Go Back')),
          ],
        ),
      ),
    );
  }
}
