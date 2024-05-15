import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:library_app/Model/User.dart';
import 'package:library_app/Model/registration_form.dart';
import 'package:library_app/Model/vaidator.dart';
import 'package:library_app/main.dart';

class Registration {
  static Registration? _instance;
  final List<ValidatorClosure> _validators = List.empty(growable: true);
  static final DatabaseReference _dbUsersReference = FirebaseDatabase
    .instance
    .refFromURL(dbUrlPath)
    .child("Users");

  Registration._create() {
    Registration._instance = this;

    _validators.add(Validator.getValidator(type: ValidatorType.fNameVT));
    _validators.add(Validator.getValidator(type: ValidatorType.lNameVT));
    _validators.add(Validator.getValidator(type: ValidatorType.emailVT));
    _validators.add(Validator.getValidator(type: ValidatorType.passwordVT));
  }

  static Registration getInstance(){
    Registration._instance ??= Registration._create();

    return Registration._instance!;
  }

  (bool, String?) validateForm({required RegistrationForm form}) {
    for (var validator in _validators) {
      var result = validator(form: form);

      if (!result.$1) {
        return result;
      }
    }

    return (true, null);
  }

  static void tryToRegister({required RegistrationForm validatedForm, required Function onCompleting}) async {
    String result = "Successfully registered!";
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: validatedForm.email!,
        password: validatedForm.password!,
      );

      var user = CustomUser(firstName: validatedForm.firstName!, lastName: validatedForm.lastName!);
      
      await _dbUsersReference.child(CustomUser.getKey(validatedForm.email!)).set(user.toJson());
    } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      result = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      result = 'The account already exists for that email.';
    }
    } catch (e) {
      result = e.toString();
    }

    onCompleting(result);
  }

}