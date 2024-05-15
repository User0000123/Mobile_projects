package by.bsuir.library.model

import by.bsuir.library.activities.addComment
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.gson.GsonBuilder
import kotlinx.coroutines.future.await
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.tasks.await
import java.util.concurrent.CompletableFuture

class ReviewsLoader {
    companion object {
        private val databaseReference: DatabaseReference = FirebaseDatabase.getInstance().getReferenceFromUrl(dbUrlPath).child("Reviews")
        private val gson = GsonBuilder().create()

        fun loadReviews(id: String) {
            databaseReference.child(id).get().addOnSuccessListener {
                for (jsonEncodedReview in it.children) {
                    addComment(gson.fromJson(gson.toJson(jsonEncodedReview.value), Comment::class.java))
                }
            }
        }
    }
}


