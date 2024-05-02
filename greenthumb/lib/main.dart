import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenthumb/firebase_options.dart';
import 'package:greenthumb/screens/home.dart';

import 'package:greenthumb/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
  // const TextStyle appTextStyle = TextStyle(
  //   fontFamily: GoogleFonts.aBeeZeeTextTheme({

  //   }), // Replace with your desired font family
  //   fontSize: 16.0, // Adjust font size as needed
  //   fontWeight: FontWeight.normal, // Adjust font weight as needed
  //   color: Colors.black,
  // );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            String userID = snapshot.data!.uid;
            return HomePage(userid: userID);
          }
          return Login();
        },
      ),
    );
  }
}
