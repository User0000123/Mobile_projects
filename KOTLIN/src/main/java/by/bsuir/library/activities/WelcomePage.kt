package by.bsuir.library.activities

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import by.bsuir.library.R
import by.bsuir.library.model.CustomUser
import by.bsuir.library.model.LogIn
import by.bsuir.library.model.LogInForm
import by.bsuir.library.model.dbUrlPath
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.tasks.await
import java.util.concurrent.CompletableFuture

lateinit var customUser: CustomUser
var dbUsers = FirebaseDatabase.getInstance().getReferenceFromUrl(dbUrlPath).child("Users")

open class WelcomePage: AppCompatActivity() {
    private lateinit var email: EditText
    private lateinit var password: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        if (FirebaseAuth.getInstance().currentUser == null) {
            email = findViewById(R.id.editTextEmailAddress)
            password = findViewById(R.id.editTextTextPassword)
        } else {
            openAccess(this)
        }
    }

    fun onLogInClick(v: View) {
        val form = LogInForm(email.text.toString(), password.text.toString())

        LogIn.performLogin(form) {
            val toast = Toast(v.context)

            toast.setText(it)
            toast.show()

            if (FirebaseAuth.getInstance().currentUser != null) {
                openAccess(this)
            }
        }
    }

    fun onSignUpClick(v: View) {
        val intent = Intent(v.context, SignUp::class.java)
        startActivity(intent)
    }

    companion object {
        fun openAccess(activity: Activity){
            val intent = Intent(activity, NavigationScreen::class.java)
            activity.startActivity(intent)
            activity.finish()
        }
    }
}