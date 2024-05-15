package by.bsuir.library.model

import android.content.Context
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.storage.FirebaseStorage
import com.google.firebase.storage.StorageReference
import com.google.gson.GsonBuilder
import kotlinx.coroutines.async
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.tasks.await
import java.util.concurrent.CompletableFuture

const val dbUrlPath = "https://mpproject-750b8-default-rtdb.europe-west1.firebasedatabase.app/"
const val sgUrlPath = "gs://mpproject-750b8.appspot.com"
val filter = Filters(false, "", "")

class Library(private var context: Context, val onDataChanged: () -> Unit) {
    var books: MutableList<Book> = mutableListOf()
    private var dbLibraryReference: DatabaseReference = FirebaseDatabase
        .getInstance()
        .getReferenceFromUrl(dbUrlPath)
        .child("Library")
    private var storageReference: StorageReference = FirebaseStorage
        .getInstance()
        .getReferenceFromUrl(sgUrlPath)
        .child("images")
    private var imagesCache: CacheManager = CacheManager(context, storageReference, 30)
    private var filters: Filters? = null

    val booksCount: Int
        get() = books.size

    init {
        filters = Filters(isWithoutReviews = false, fromPrice = "", toPrice = "")
    }

    fun getBook(index: Int): Book? {
        return books.getOrNull(index)
    }

    fun loadLibrary(filter: ((Book) -> Boolean)? = null) {
        books.clear()
        dbLibraryReference.orderByKey().get().addOnSuccessListener {
            it.children.forEach { jsonEncodedBook ->
                val book = gson.fromJson(gson.toJson(jsonEncodedBook.value), Book::class.java)
                book.ID = jsonEncodedBook.key!!
                println(book.toString())

                if (filter == null || filter(book)) {
                    books.add(book)
                }

                book.images = mutableListOf()
                book.images!!.add(CompletableFuture.completedFuture(runBlocking { imagesCache.get(book.imagesLinks[0]) }).get())
                CompletableFuture.completedFuture(runBlocking { loadBookImages(book) }).get()
            }
            onDataChanged()
        }
    }

    private suspend fun loadBookImages(book: Book, reloadState: (() -> Unit)? = null) {
        book.images!!.clear()
        book.imagesLinks.forEach { imageLink ->
            book.images!!.add(imagesCache.get(imageLink).also { reloadState?.invoke() })
        }
    }

    companion object {
        private var gson = GsonBuilder().create()

        fun updateBook(book: Book) {
            val dbBook = FirebaseDatabase.getInstance().getReferenceFromUrl(dbUrlPath).child("Library")
            CompletableFuture.completedFuture(runBlocking { dbBook.child(book.ID).setValue(book.toJson()) }).get()
        }
    }
}


