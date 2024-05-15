package by.bsuir.library.activities

import android.content.Intent
import android.graphics.Rect
import android.os.Bundle
import android.view.MotionEvent
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import by.bsuir.library.MainActivity
import by.bsuir.library.R
import by.bsuir.library.fragments.BooksTable
import by.bsuir.library.fragments.FavouritesTable
import by.bsuir.library.fragments.UserProfile
import by.bsuir.library.model.CustomUser
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.gson.GsonBuilder
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.tasks.await
import java.util.concurrent.CompletableFuture
import java.util.concurrent.ThreadPoolExecutor

class NavigationScreen: AppCompatActivity(){

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.navigation_bar)

        val gson = GsonBuilder().create()
        CompletableFuture.completedFuture(runBlocking {
            dbUsers.child(CustomUser.getKey(FirebaseAuth.getInstance().currentUser!!.email!!)).get().addOnSuccessListener {
                customUser = gson.fromJson(gson.toJson(it.value), CustomUser::class.java)
                if (customUser.favourites == null) {
                    customUser.favourites = mutableListOf()
                }
            }
        }).get()

        val fragments = listOf(BooksTable(), FavouritesTable(), UserProfile())
        val bottomNavigationView = findViewById<BottomNavigationView>(R.id.navBar)

        bottomNavigationView.selectedItemId = R.id.nav_books
        setCurrentFragment(fragments[0])

        bottomNavigationView.setOnItemSelectedListener {
            when (it.itemId) {
                R.id.nav_books -> setCurrentFragment(fragments[0])
                R.id.nav_favourites -> setCurrentFragment(fragments[1])
                R.id.nav_profile -> setCurrentFragment(fragments[2])
            }
            true
        }
    }

    private fun setCurrentFragment(fragment: Fragment)=
    supportFragmentManager.beginTransaction().apply {
        replace(R.id.fragments_space, fragment)
        commit()
    }

    override fun dispatchTouchEvent(event: MotionEvent): Boolean {
        if (event.action == MotionEvent.ACTION_DOWN) {
            val v = currentFocus
            if (v is EditText) {
                val outRect = Rect()
                v.getGlobalVisibleRect(outRect)
                if (!outRect.contains(event.rawX.toInt(), event.rawY.toInt())) {
                    v.clearFocus()
                    val imm = getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
                    imm.hideSoftInputFromWindow(v.getWindowToken(), 0)
                }
            }
        }
        return super.dispatchTouchEvent(event)
    }

    fun onFilterButtonClick(view: View){
        val intent = Intent(view.context, FilterScreen::class.java)
        startActivity(intent)
    }

    fun onSignOut(v: View) {
        val intent = Intent(v.context, MainActivity::class.java)

        FirebaseAuth.getInstance().signOut()

        startActivity(intent)
        finish()
    }

    fun onDeleteUser(v: View){
        FirebaseAuth.getInstance().currentUser!!.delete().addOnCompleteListener {
            val intent = Intent(v.context, MainActivity::class.java)
            startActivity(intent)
            finish()
        }
    }
}