package by.bsuir.library.activities

import android.annotation.SuppressLint
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.viewpager.widget.ViewPager
import by.bsuir.library.R
import by.bsuir.library.adapters.openedBook
import by.bsuir.library.custom.ImageSliderAdapter
import by.bsuir.library.fragments.favUpdater
import by.bsuir.library.model.Book
import by.bsuir.library.model.Comment
import by.bsuir.library.model.ReviewsLoader
import java.util.Locale

lateinit var addComment: (Comment) -> Unit
lateinit var bindData: ()->Unit

class DetailedBookPage: AppCompatActivity() {
    lateinit var imageSlider: ViewPager
    lateinit var title: TextView
    lateinit var authors: TextView
    lateinit var rating: TextView
    lateinit var ratingsCount: TextView
    lateinit var price: TextView
    lateinit var liked: ImageView
    lateinit var commentsStack: LinearLayout

    @SuppressLint("SetTextI18n")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.detailde_item_screen)

        imageSlider = findViewById(R.id.viewPager)
        title = findViewById(R.id.det_book_title)
        authors = findViewById(R.id.det_book_authors)
        rating = findViewById(R.id.rating)
        ratingsCount = findViewById(R.id.ratingsCount)
        liked = findViewById(R.id.likeButton)
        price = findViewById(R.id.price)
        commentsStack = findViewById(R.id.comments)

        val viewPagerAdapter = ImageSliderAdapter(this, openedBook.images)
        imageSlider.adapter = viewPagerAdapter

        addComment = this::addComment
        ReviewsLoader.loadReviews(openedBook.ID)

        bindData()
        bindData = this::bindData
    }

    fun addComment(comment: Comment) {
        val view = layoutInflater.inflate(R.layout.review_item, commentsStack, false)
        view.findViewById<TextView>(R.id.author).text = comment.email
        view.findViewById<TextView>(R.id.description).text = comment.description

        commentsStack.addView(view)
    }

    fun bindData(){
        title.text = openedBook.title
        authors.text = openedBook.authors.joinToString()
        rating.text = String.format(Locale.getDefault(), "%.2f", openedBook.rating)
        ratingsCount.text = "(${openedBook.ratingsNumber} ratings)"
        price.text = "\$ ${openedBook.price}"
        liked.setColorFilter(if (customUser.favourites!!.contains(openedBook.ID)) Color.RED else Color.BLACK)
    }

    fun onAddReviewClick(view: View) {
        val intent = Intent(view.context, ReviewScreen::class.java)
        startActivity(intent)
    }

    fun onLikeClicked(v: View) {
        if (customUser.favourites!!.contains(openedBook.ID)) {
            liked.setColorFilter(Color.BLACK)
            customUser.favourites!!.remove(openedBook.ID)
        } else {
            liked.setColorFilter(Color.RED)
            customUser.favourites!!.add(openedBook.ID)
        }

        customUser.updateUser()
        favUpdater?.invoke(null)
    }
}