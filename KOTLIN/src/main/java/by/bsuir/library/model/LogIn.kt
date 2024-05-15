package by.bsuir.library.model

import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.tasks.await
import java.util.concurrent.CompletableFuture

class LogIn {
    companion object {
        fun performLogin(form: LogInForm, onComplete: (String)->Unit){
            var result = "Successfully logged in"

            CompletableFuture.completedFuture(runBlocking {
                if ((form.email?.isEmpty() != true) && (form.password?.isEmpty() != true))
                    FirebaseAuth.getInstance().signInWithEmailAndPassword(form.email!!, form.password!!)
                        .addOnCompleteListener {
                            if (!it.isSuccessful) {
                                result = it.exception.toString()
                            }

                            onComplete(result)
                        }
                else {
                    result = "At least one field of the form is empty"
                    onComplete(result)
                }
            }).get()
        }
    }
}