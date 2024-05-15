import 'package:flutter/material.dart';
import 'package:library_app/Model/registration.dart';
import 'package:library_app/Model/registration_form.dart';
import 'package:library_app/View/navigation_bar.dart';
import 'package:library_app/main.dart';

Map<String, TextEditingController> tfControlls = {
  "firstName" : TextEditingController(), 
  "lastName" : TextEditingController(), 
  "email" : TextEditingController(), 
  "password" : TextEditingController()
};
Registration registration = Registration.getInstance();

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
	
	@override
	Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: const Column(
        children: [
          Expanded(
            flex: 1,
            child: _HeaderSection()
          ),
          Expanded(
            flex: 3,
            child: _SignUpFieldsSection(),
          ),
          Expanded(
            flex: 2,
            child: _SignUpButtonSection(),
          )
        ]
      )
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
          "Welcome to BookStore!",
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

class _SignUpFieldsSection extends StatelessWidget {
  const _SignUpFieldsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(20), 
          child: 
            TextField(
              controller: tfControlls["firstName"],
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.grey)
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                hintText: "First name"
              ),
            ),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20), 
          child: 
            TextField(
              controller: tfControlls["lastName"],
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.grey)
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                hintText: "Last name"
              ),
            ),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 20), 
          child: 
            TextField(
              controller: tfControlls["email"],
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
          padding: const EdgeInsets.all(20), 
          child: 
            TextField(
              controller: tfControlls["password"],
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

class _SignUpButtonSection extends StatelessWidget {
  const _SignUpButtonSection();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const FractionalOffset(0.5, 0.2),
      child: SizedBox(width: 130, child:
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo
          ),
          child: const Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white
            ),
          ),  
          onPressed: () {
            RegistrationForm registrationForm = RegistrationForm(
              tfControlls["firstName"]?.text, 
              tfControlls["lastName"]?.text,
              tfControlls["email"]?.text.toLowerCase(),
              tfControlls["password"]?.text
            );

            var validationResult = registration.validateForm(form: registrationForm);
            if (validationResult.$1) {
              Registration.tryToRegister(validatedForm: registrationForm, onCompleting: (String errorMessage) => 
              showCustomDialog(context, "Registration info", errorMessage).whenComplete(() {
                assignCustomUser();
                if (isUserLoggedIn()) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationScreen()));
                }
                }));              
            } else {
              showCustomDialog(context, "Validation error", validationResult.$2!);              
            }
          },
        )
      )
    );
  }
}