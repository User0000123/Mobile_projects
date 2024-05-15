package by.bsuir.library.activities

import android.os.Bundle
import android.view.View
import android.widget.CheckBox
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import by.bsuir.library.R
import by.bsuir.library.fragments.libraryUpdater
import by.bsuir.library.model.filter

class FilterScreen: AppCompatActivity() {
    lateinit var fromPrice: EditText
    lateinit var toPrice: EditText
    lateinit var isWithoutReviews: CheckBox

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.filter_screen)

        fromPrice = findViewById(R.id.fromPrice)
        toPrice = findViewById(R.id.toPrice)
        isWithoutReviews = findViewById(R.id.cbxWithoutReviews)

        fromPrice.text.insert(0, filter.fromPrice)
        toPrice.text.insert(0, filter.toPrice)
        isWithoutReviews.isChecked = filter.isWithoutReviews
    }

    fun onFilterApply(v: View){
        filter.fromPrice = fromPrice.text.toString()
        filter.toPrice = toPrice.text.toString()
        filter.isWithoutReviews = isWithoutReviews.isChecked

        libraryUpdater.invoke {
            var result: Boolean

            result =
                it.price != null && it.price!! >= (filter.fromPrice.toDoubleOrNull() ?: 0.0)
                        && it.price!! <= (filter.toPrice.toDoubleOrNull() ?: 999.0)
            if (filter.isWithoutReviews) {
                result = result && it.ratingsNumber == 0
            }

            result
        }
        finish()
    }
}