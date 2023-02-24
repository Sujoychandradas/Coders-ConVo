import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coders_combo_chatapp/constanst/Constants.dart';
import 'package:coders_combo_chatapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //For google signin
  GoogleSignIn googleSignIn = GoogleSignIn(); //google sign in instance
  FirebaseFirestore firestore = FirebaseFirestore.instance; //To store userdata firebase

  Future signInFunction() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      //If the user don't click signIN button and click back then the user will be returned
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken); //google sign IN authentication
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential); //this line of code used for access the account authentication and store the information

    DocumentSnapshot userExits = await usersRef.doc(userCredential.user!.uid).get();

    if (userExits.exists) {
      print("User Already Exits in Database");
    } else {
      await usersRef.doc(userCredential.user!.uid).set({
        "email": userCredential.user!.email,
        "name": userCredential.user!.displayName,
        "Image": userCredential.user!.photoURL,
        "uid": userCredential.user!.uid,
        "date": DateTime.now(),
      });
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/pictures/v1.png",
                  ),
                  // image: Image.asset("assets/pictures/v1.png"),
                ),
              ),
            ),
          ),
          // Text(
          //   "Flutter Chat App",
          //   style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ElevatedButton(
              onPressed: () async {
                await signInFunction();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/pictures/google.png",
                    height: 25,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Sign in With Google",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
