package by.bsuir.library.model

import android.provider.ContactsContract.RawContacts.Data
import by.bsuir.library.activities.customUser
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.gson.GsonBuilder

class CustomUser(var firstName: String?, var lastName: String?) {
    var favourites: MutableList<String>? = mutableListOf()

    init {
        favourites = mutableListOf()
    }

    fun updateUser() {
        val users = FirebaseDatabase.getInstance().getReferenceFromUrl(dbUrlPath).child("Users")
        val gson = GsonBuilder().create()
        users.child(getKey(FirebaseAuth.getInstance().currentUser!!.email!!)).setValue(customUser.toJson())
    }

    fun toJson(): MutableMap<String, Any> {
        return mutableMapOf(
            "firstName" to this.firstName!!,
            "lastName" to this.lastName!!,
            "favourites" to this.favourites!!
        )
    }

    companion object {
        fun getKey(email: String): String {
            return email.replace(Regex("\\."), "");
        }
    }
}