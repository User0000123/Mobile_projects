package by.bsuir.library.fragments

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.ArrayAdapter
import android.widget.ListView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.RecyclerView
import by.bsuir.library.MainActivity
import by.bsuir.library.R
import by.bsuir.library.activities.customUser
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import kotlinx.coroutines.runBlocking
import java.util.concurrent.CompletableFuture

lateinit var updateProfile: () -> Unit

class UserProfile: Fragment(R.layout.user_profile) {
    val userProfile: MutableMap<String, String> = mutableMapOf()
    lateinit var profile_list: ListView
    val list = mutableListOf<String>()

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {

        super.onViewCreated(view, savedInstanceState)

        profile_list = requireActivity().findViewById(R.id.profile_info)
        val adapter = ArrayAdapter(requireActivity(), android.R.layout.simple_list_item_1, list)

        profile_list.adapter = adapter
        updateProfile = {
            initProfile()
            adapter.notifyDataSetChanged()
        }

        updateProfile()
    }

    private fun initProfile(){
        userProfile.clear()

        val firebaseUser = FirebaseAuth.getInstance().currentUser!!

        userProfile["First name"] = customUser.firstName!!
        userProfile["Last name"] = customUser.lastName!!
        userProfile["Email"] = firebaseUser.email!!
        userProfile["Is email verified"] = firebaseUser.isEmailVerified.toString()
        userProfile["Is anonymous"] = firebaseUser.isAnonymous.toString()
        userProfile["Providers UID"] = firebaseUser.uid
        userProfile["Tenant ID"] = firebaseUser.tenantId ?: "nil"
        userProfile["Refresh token"] = firebaseUser.getIdToken(true).toString()
        userProfile["Creation date"] = firebaseUser.metadata!!.creationTimestamp.toString()
        userProfile["Favourites count"] = customUser.favourites!!.size.toString()

        list.clear()
        list.addAll(userProfile.toList().map { it.first + " : " + it.second })
    }
}