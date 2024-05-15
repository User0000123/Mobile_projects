package by.bsuir.library.model

import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import kotlinx.coroutines.future.await
import kotlinx.coroutines.runBlocking
import java.util.concurrent.CompletableFuture

class Registration private constructor() {
    private val validators = mutableListOf<ValidatorClosure>()
    companion object {
        private var instance: Registration? = null

        fun getInstance(): Registration {
            if (instance == null) {
                instance = Registration()
            }
            return instance!!
        }

        fun tryToRegister(validatedForm: RegistrationForm, onCompleting: (String) -> Unit) {
            var result = "Successfully registered!"

            CompletableFuture.completedFuture(runBlocking {
                val validationRes = getInstance().validateForm(validatedForm)
                if (validationRes.first) {
                    FirebaseAuth.getInstance().createUserWithEmailAndPassword(
                        validatedForm.email!!,
                        validatedForm.password!!
                    )
                        .addOnCompleteListener {
                            if (!it.isSuccessful) {
                                result = it.exception.toString()
                            }

                            onCompleting(result)
                        }
                } else {
                    onCompleting(validationRes.second!!)
                }
            }).get()
        }
    }

    init {
        validators.add(Validator.getValidator(type = ValidatorType.FNameVT))
        validators.add(Validator.getValidator(type = ValidatorType.LNameVT))
        validators.add(Validator.getValidator(type = ValidatorType.EmailVT))
        validators.add(Validator.getValidator(type = ValidatorType.PasswordVT))
    }

    fun validateForm(form: RegistrationForm): Pair<Boolean, String?> {
        for (validator in validators) {
            val result = validator(form)
            if (!result.first) {
                return result
            }
        }
        return Pair(true, null)
    }
}


