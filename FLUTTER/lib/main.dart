import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_app/Model/user.dart';
import 'package:library_app/View/navigation_bar.dart';
import 'package:library_app/View/welcome_screen.dart';

late CustomUser customUser;
const String dbUrlPath = "https://mpproject-750b8-default-rtdb.europe-west1.firebasedatabase.app";
const String sgUrlPath = "gs://mpproject-750b8.appspot.com";

void main(List<String> args) async {
  await _firebaseInitialization();
	Future.microtask(_applicationInitialization);

  runApp(const _Application());
}

class _Application extends StatelessWidget {
  const _Application(); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
			debugShowCheckedModeBanner: false,
			home : FirebaseAuth.instance.currentUser == null ? const WelcomeScreen() : NavigationScreen()
    );
  }
}

Future _firebaseInitialization() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await assignCustomUser();

  FirebaseDatabase.instance.setPersistenceEnabled(true);
}

void _applicationInitialization() {  
  SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
}

Future assignCustomUser() async {
  DatabaseReference dbUsers = FirebaseDatabase.instance.refFromURL(dbUrlPath).child("Users");
  if (FirebaseAuth.instance.currentUser != null) {
    await dbUsers.child(CustomUser.getKey(FirebaseAuth.instance.currentUser!.email!)).get().then((value){
      if (value.exists) {
        customUser = CustomUser.fromJson(value.value as Map);
        return true;
      }
    }
    );
  }

  return false;
}

void updateUser() async {
  DatabaseReference dbUsers = FirebaseDatabase.instance.refFromURL(dbUrlPath).child("Users");
  if (FirebaseAuth.instance.currentUser != null) {
    await dbUsers.child(CustomUser.getKey(FirebaseAuth.instance.currentUser!.email!)).set(customUser.toJson());
  }
}

bool isUserLoggedIn() {
  return FirebaseAuth.instance.currentUser != null;
}

Future showCustomDialog(BuildContext context, String title, String message) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}