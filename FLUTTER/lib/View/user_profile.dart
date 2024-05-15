import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/Model/user.dart';
import 'package:library_app/View/detailed_item_screen.dart';
import 'package:library_app/View/welcome_screen.dart';
import 'package:library_app/main.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<StatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Function loader;
  Map<String, String> userInfoMap = {};

  @override
  void initState() {
    super.initState();
    loader = () {
      var firebaseUser = FirebaseAuth.instance.currentUser!;
      userInfoMap.clear();


      userInfoMap["First name"] = customUser.firstName!;
      userInfoMap["Last name"] = customUser.lastName!;
      userInfoMap["Email"] = firebaseUser.email!;
      userInfoMap["Is email verified"] = firebaseUser.emailVerified.toString();
      userInfoMap["Is anonymous"] = firebaseUser.isAnonymous.toString();
      userInfoMap["Providers UID"] = firebaseUser.uid;
      userInfoMap["Tenant ID"] = firebaseUser.tenantId?? "nil";
      userInfoMap["Refresh token"] = firebaseUser.refreshToken ?? "nil";
      userInfoMap["Creation date"] = firebaseUser.metadata.creationTime!.toString();
      userInfoMap["Favourites count"] = customUser.favourites == null ? 0.toString() : customUser.favourites!.length.toString();

      if (mounted) setState((){});
    };
    loader();
    notification.add(loader);
  }

  @override
  void dispose() {
    notification.remove(loader);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          flex: 2,
          child: _HeaderSection()
        ),
        Expanded(
          flex: 6,
          child: _ListSection(userInfoMap)
        ),
        const Expanded(
          flex: 1,
          child: _ButtonsSection()
        )
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();
  
  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: FractionalOffset(0.5, 0.7),
      child: Text(
        "User profile",
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontSize: 33,
          fontWeight: FontWeight.bold,
          color: Colors.indigo
        ),
      ),
    );
  }
}

class _ListSection extends StatelessWidget {
  final Map<String, String> userInfo;

  const _ListSection(this.userInfo);
  
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) => ListTile(
        title: Text(
            "${userInfo.entries.elementAt(index).key} : ${userInfo.entries.elementAt(index).value}",
            style: const TextStyle(
              fontSize: 20
            ),
          ),
        ), 
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

class _ButtonsSection extends StatelessWidget {
  const _ButtonsSection();
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 160, child:
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo
            ),
            child: const Text(
              "Sign Out",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
            ),  
            onPressed: () {
              FirebaseAuth.instance.signOut();
              customUser = CustomUser(firstName: "", lastName: "");
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()), (route) => false);
            },
          )
        ),
        SizedBox(width: 160, child:
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo
            ),
            child: const Text(
              "Delete user",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
            ),  
            onPressed: () {
              FirebaseAuth.instance.currentUser!.delete();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()), (route) => false);
            },
          )
        ),
      ],
    );
  }
}