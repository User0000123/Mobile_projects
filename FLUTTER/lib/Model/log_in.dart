import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/Model/log_in_form.dart';

class LogIn{
  static void performLogIn({required LogInForm form, required Function onCompleting}) async {
    String result = "Successfully logged in";
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: form.email!,
        password: form.password!
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        result = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        result = 'Wrong password provided for that user.';
      }
      result = e.toString();
    } catch (e) {
      result = e.toString();
    }

    onCompleting(result);
  }
}