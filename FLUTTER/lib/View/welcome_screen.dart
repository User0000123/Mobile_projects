import 'package:flutter/material.dart';
import 'package:library_app/Model/log_in.dart';
import 'package:library_app/Model/log_in_form.dart';
import 'package:library_app/View/sign_up.dart';
import 'package:library_app/View/navigation_bar.dart';
import 'package:library_app/main.dart';

final Map<String, TextEditingController> controlls = {
  "login" : TextEditingController(),
  "password" : TextEditingController()
};

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
	
	@override
	Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: _HeaderSection()
            ),
            Expanded(
              flex: 4,
              child: _LogInFieldsSection()
            ),
            Expanded(
              flex: 2,
              child: _LogInButtonsSection()
            ),
          ]
        )
      )
    );
	}
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();
  
  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: Text(
          "BookStore",
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.indigo
          ),
      ),
    );
  }
}

class _LogInFieldsSection extends StatelessWidget {
  const _LogInFieldsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Log In",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w500
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(20), 
          child: 
            TextField(
              controller: controlls["login"],
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.grey)
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                hintText: "Email"
              ),
            ),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 20), 
          child: 
            TextField(
              controller: controlls["password"],
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.grey)
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                hintText: "Password"
              ),
              obscureText: true,
            ),
        ),
      ],
    );
  }
}

class _LogInButtonsSection extends StatelessWidget {
  const _LogInButtonsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: 130, child:
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo
            ),
            child: const Text(
              "Log In",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white
              ),
            ),  
            onPressed: () async {
              LogInForm form = LogInForm(controlls["login"]!.text, controlls["password"]!.text);

              LogIn.performLogIn(form: form, onCompleting: (info) => showCustomDialog(context, "Sign in info", info).whenComplete(
                () async {     
                  await assignCustomUser();
                  if (isUserLoggedIn()) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationScreen()));
                  }
                }
              ));
            },
          )
        ),
        SizedBox(width: 130, child:
          TextButton(
            child: const Text(
              "or Sign Up",
              style: TextStyle(
                fontSize: 20,
                color: Colors.indigo,
              ),
            ),
            onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()))                  
          )
        ),
      ],
    );
  }
}