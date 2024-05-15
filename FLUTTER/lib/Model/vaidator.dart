import 'package:library_app/Model/registration_form.dart';

typedef ValidatorClosure = (bool, String?) Function({required RegistrationForm form});

enum ValidatorType {
  emailVT, passwordVT, fNameVT, lNameVT 
}

class Validator {
  static ValidatorClosure getValidator({required ValidatorType type}) {
    return switch (type) {
      ValidatorType.emailVT => _validateEmail,
      ValidatorType.passwordVT => _validatePassword,
      ValidatorType.fNameVT => _validateName,
      ValidatorType.lNameVT => _validateName
    };
  }

  static (bool, String?) _validateEmail({required RegistrationForm form}) {
    bool result = !form.email!.contains(RegExp("\\s", unicode: true));
    return (result, result ? null : "The email doesn't meet the requirements!");
  }

  static (bool, String?) _validatePassword({required RegistrationForm form}) {
    bool result = !form.password!.contains(RegExp("\\s", unicode: true));
    return (result, result ? null : "The password doesn't meet the requirements!");
  }

  static (bool, String?) _validateName({required RegistrationForm form}) {
    bool result = !form.firstName!.contains(RegExp("\\s", unicode: true)) && !form.lastName!.contains(RegExp("\\s", unicode: true));
    return (result, result ? null : "Names don't meet the requirements!");
  }
}