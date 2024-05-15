package by.bsuir.library.adapters

import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.view.LayoutInflater
import android.view.View
import android.view.View.OnClickListener
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import by.bsuir.library.R
import by.bsuir.library.activities.DetailedBookPage
import by.bsuir.library.model.Book
import java.util.Locale

lateinit var openedBook: Book

class BooksPreviewAdapter(var context: Context?, var books: List<Book>) :
    RecyclerView.Adapter<BooksPreviewAdapter.ViewHolder>() {

    private val inflater: LayoutInflater = LayoutInflater.from(context)
    override fun getItemCount() = books.size

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = inflater.inflate(R.layout.list_item, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val book: Book = books[position]
        holder.bookTitle.text = book.title
        holder.bookAuthors.text = book.authors.joinToString()
        holder.bookRating.text = String.format(Locale.getDefault(), "%.2f", book.rating)
        holder.bookPrice.text = book.price?.toString() ?: ""
        if (book.images != null) {
            holder.image.setImageBitmap(BitmapFactory.decodeByteArray(book.images!![0], 0, book.images!![0].size))
        } else {
            holder.image.setImageResource(R.drawable.baseline_broken_image_100)
        }
    }

    inner class ViewHolder(view: View) : RecyclerView.ViewHolder(view), OnClickListener {
        val bookTitle: TextView = view.findViewById(R.id.book_title)
        val bookAuthors: TextView = view.findViewById(R.id.book_authors)
        val bookRating: TextView = view.findViewById(R.id.book_rating)
        val bookPrice: TextView = view.findViewById(R.id.book_price)
        val image: ImageView = view.findViewById(R.id.image)

        init {
            view.setOnClickListener(this)
        }

        override fun onClick(v: View?) {
            if (adapterPosition == RecyclerView.NO_POSITION) return

            val intent = Intent(context, DetailedBookPage::class.java)
            openedBook = books[adapterPosition]
            context!!.startActivity(intent)
        }
    }
}