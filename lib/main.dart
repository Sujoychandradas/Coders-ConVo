import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coders_combo_chatapp/model/user_model.dart';
import 'package:coders_combo_chatapp/screens/auth_screen.dart';
import 'package:coders_combo_chatapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //after creating the flutter projcet
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform, //For the first error PlatformException (PlatformException(null-error, Host platform returned null value for non-null return value., null, null))
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

//This mehtod is used for checking if the user singed out or not
//If the user is not signed out still can asscess the app
  Future<Widget> UserSignedIn() async { User? user = FirebaseAuth.instance.currentUser;
    if (user != null) { DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      UserModel userModel = UserModel.fromJson(userData); //sending data in user Model
      return HomeScreen(userModel);
    } else 
    {
      return const AuthScreen();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Coders Combo ChatApp",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: AuthScreen(),
      home: FutureBuilder(
          future: UserSignedIn(),
          builder: (context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!; //it simply means return the widget
            }
            return Scaffold(body: Center(child: CircularProgressIndicator(), ),
            );
          } ),
      debugShowCheckedModeBanner: false,
    );
  }
}