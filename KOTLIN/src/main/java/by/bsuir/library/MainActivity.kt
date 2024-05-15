package by.bsuir.library

import android.content.Intent
import android.graphics.Rect
import android.os.Bundle
import android.view.MotionEvent
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import by.bsuir.library.activities.FilterScreen
import by.bsuir.library.activities.NavigationScreen
import by.bsuir.library.activities.WelcomePage
import by.bsuir.library.fragments.BooksTable
import by.bsuir.library.fragments.FavouritesTable
import by.bsuir.library.fragments.UserProfile
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.ktx.Firebase


class MainActivity : WelcomePage() {
}