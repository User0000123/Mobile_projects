package by.bsuir.library.activities

import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import by.bsuir.library.R
import by.bsuir.library.model.LogIn
import by.bsuir.library.model.LogInForm
import by.bsuir.library.model.Registration
import by.bsuir.library.model.RegistrationForm
import com.google.firebase.auth.FirebaseAuth

class SignUp: AppCompatActivity() {
    private lateinit var firstName: EditText
    private lateinit var lastName: EditText
    private lateinit var email: EditText
    private lateinit var password: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.sign_up)

        firstName = findViewById(R.id.et_firstName)
        lastName = findViewById(R.id.et_lastName)
        email = findViewById(R.id.et_email)
        password = findViewById(R.id.et_password)
    }

    fun onTrySignUpClick(v: View) {
        val form = RegistrationForm(firstName.text.toString(),
            lastName.text.toString(),
            email.text.toString(),
            password.text.toString())

        Registration.tryToRegister(form) {
            val toast = Toast(v.context)

            toast.setText(it)
            toast.show()

            if (FirebaseAuth.getInstance().currentUser != null) {
                WelcomePage.openAccess(this)
            }
        }
    }
}