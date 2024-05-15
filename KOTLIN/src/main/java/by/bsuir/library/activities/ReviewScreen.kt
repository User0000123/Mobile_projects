package by.bsuir.library.activities

import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.RatingBar
import androidx.appcompat.app.AppCompatActivity
import by.bsuir.library.R
import by.bsuir.library.adapters.openedBook
import by.bsuir.library.fragments.favUpdater
import by.bsuir.library.fragments.libraryUpdater
import by.bsuir.library.model.Comment
import by.bsuir.library.model.Library
import by.bsuir.library.model.dbUrlPath
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.FirebaseDatabase
import com.google.gson.GsonBuilder
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.tasks.await
import java.util.concurrent.CompletableFuture

class ReviewScreen: AppCompatActivity() {
    lateinit var ratingBar: RatingBar
    lateinit var description: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.review_screen)

        ratingBar = findViewById(R.id.ratingBar)
        description = findViewById(R.id.review_text)
    }

    fun onSendReviewClick(v: View){
        val comment = Comment(FirebaseAuth.getInstance().currentUser!!.email!!, description.text.toString())
        val dbComments = FirebaseDatabase.getInstance().getReferenceFromUrl(dbUrlPath).child("Reviews")
        val gson = GsonBuilder().create()

        openedBook.rating = ((openedBook.rating * openedBook.ratingsNumber) + ratingBar.rating) / (openedBook.ratingsNumber + 1)
        openedBook.ratingsNumber++
        Library.updateBook(openedBook)

        CompletableFuture.completedFuture(runBlocking { dbComments.child(openedBook.ID).push().setValue(comment.toJson()).addOnCompleteListener {
            libraryUpdater { true }
            favUpdater?.invoke(null)

            addComment(comment)
            bindData()

            finish()
        } }).get()
    }
}