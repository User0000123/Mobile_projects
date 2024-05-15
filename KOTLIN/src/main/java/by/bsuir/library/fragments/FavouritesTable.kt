package by.bsuir.library.fragments

import android.content.Context
import android.os.Bundle
import android.view.View
import android.widget.SearchView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import by.bsuir.library.R
import by.bsuir.library.activities.customUser
import by.bsuir.library.adapters.BooksPreviewAdapter
import by.bsuir.library.model.Book
import by.bsuir.library.model.Library

var favUpdater: ((((Book) -> Boolean)?) -> Unit)? = null

@Suppress("DEPRECATION")
class FavouritesTable: Fragment(R.layout.favourites_screen){
    private lateinit var library: Library
    private lateinit var recyclerView: RecyclerView

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val adapter = BooksPreviewAdapter(activity, listOf())
        recyclerView = requireActivity().findViewById(R.id.listFav)
        recyclerView.adapter = adapter
        val dividerItemDecoration = DividerItemDecoration(recyclerView.context, LinearLayoutManager.VERTICAL)
        recyclerView.addItemDecoration(dividerItemDecoration)

        library = Library(this.requireContext(), adapter::notifyDataSetChanged)
        adapter.books = library.books

        favUpdater = {library.loadLibrary {
            customUser.favourites!!.contains(it.ID)
        }}

        library.loadLibrary {
            customUser.favourites!!.contains(it.ID)
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putParcelable("favView", recyclerView.layoutManager!!.onSaveInstanceState())
    }

    override fun onViewStateRestored(savedInstanceState: Bundle?) {
        super.onViewStateRestored(savedInstanceState)
        if (savedInstanceState != null)
            recyclerView.layoutManager!!.onRestoreInstanceState(savedInstanceState.getParcelable("favView"))
    }
}