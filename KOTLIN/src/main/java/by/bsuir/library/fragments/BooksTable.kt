package by.bsuir.library.fragments

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.SearchView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import by.bsuir.library.R
import by.bsuir.library.activities.FilterScreen
import by.bsuir.library.adapters.BooksPreviewAdapter
import by.bsuir.library.model.Book
import by.bsuir.library.model.Library

lateinit var libraryUpdater: ((Book) -> Boolean) -> Unit

@Suppress("DEPRECATION")
class BooksTable: Fragment(R.layout.books_table_view) {
    private lateinit var library: Library
    private lateinit var recyclerView: RecyclerView

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val adapter = BooksPreviewAdapter(activity, listOf())
        recyclerView = requireActivity().findViewById(R.id.list)
        recyclerView.adapter = adapter
        val dividerItemDecoration = DividerItemDecoration(recyclerView.context, LinearLayoutManager.VERTICAL)
        recyclerView.addItemDecoration(dividerItemDecoration)

        library = Library(this.requireContext(), adapter::notifyDataSetChanged)
        adapter.books = library.books

        library.loadLibrary()
        libraryUpdater = library::loadLibrary

        val searchBar = requireActivity().findViewById<SearchView>(R.id.searchBar)
        searchBar.setOnQueryTextListener(object: SearchView.OnQueryTextListener{
            override fun onQueryTextSubmit(query: String): Boolean {
                libraryUpdater {
                    if (query.isNotEmpty()) it.title.contains(query, ignoreCase = true) else true
                }
                return false
            }
            override fun onQueryTextChange(newText: String): Boolean {
                return false
            }
        })
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putParcelable("recView", recyclerView.layoutManager!!.onSaveInstanceState())
    }

    override fun onViewStateRestored(savedInstanceState: Bundle?) {
        super.onViewStateRestored(savedInstanceState)
        if (savedInstanceState != null)
            recyclerView.layoutManager!!.onRestoreInstanceState(savedInstanceState.getParcelable("recView"))
    }

    fun onFilterButtonClick(view: View){
        val intent = Intent(view.context, FilterScreen::class.java)
        startActivity(intent)
    }
}