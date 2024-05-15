package by.bsuir.library.model

typealias ValidatorClosure = (RegistrationForm) -> Pair<Boolean, String?>

enum class ValidatorType {
    EmailVT, PasswordVT, FNameVT, LNameVT
}

class Validator {
    companion object {
        fun getValidator(type: ValidatorType): ValidatorClosure {
            return when (type) {
                ValidatorType.EmailVT -> ::validateEmail
                ValidatorType.PasswordVT -> ::validatePassword
                ValidatorType.FNameVT -> ::validateName
                ValidatorType.LNameVT -> ::validateName
            }
        }

        private fun validateEmail(form: RegistrationForm): Pair<Boolean, String?> {
            val result = form.email != null && form.email!!.isNotEmpty() && !form.email!!.contains(Regex("\\s"))
            return Pair(result, if (result) null else "The email doesn't meet the requirements!")
        }

        private fun validatePassword(form: RegistrationForm): Pair<Boolean, String?> {
            val result = form.password != null && form.password!!.isNotEmpty() && !form.password!!.contains(Regex("\\s"))
            return Pair(result, if (result) null else "The password doesn't meet the requirements!")
        }

        private fun validateName(form: RegistrationForm): Pair<Boolean, String?> {
            val result = form.firstName != null && form.firstName!!.isNotEmpty() &&
                    form.lastName != null && form.lastName!!.isNotEmpty() && !form.firstName!!.contains(Regex("\\s")) && !form.lastName!!.contains(Regex("\\s"))
            return Pair(result, if (result) null else "Names don't meet the requirements!")
        }
    }
}