package by.bsuir.library.custom

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.BitmapFactory
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.viewpager.widget.PagerAdapter
import androidx.viewpager.widget.ViewPager
import by.bsuir.library.R

class ImageSliderAdapter(private val context: Context, private var imageList: MutableList<ByteArray>?) : PagerAdapter() {
    override fun getCount() = imageList!!.size
    override fun isViewFromObject(view: View, `object`: Any) = view === `object`

    @SuppressLint("InflateParams")
    override fun instantiateItem(container: ViewGroup, position: Int): Any {
        val view: View =  (context.getSystemService(Context.LAYOUT_INFLATER_SERVICE)
                as LayoutInflater).inflate(R.layout.slider_item, null)
        val ivImages = view.findViewById<ImageView>(R.id.imageView)

        ivImages.setImageBitmap(BitmapFactory.decodeByteArray(imageList!![position], 0, imageList!![position].size))

        val vp = container as ViewPager
        vp.addView(view, 0)
        return view
    }

    override fun destroyItem(container: ViewGroup, position: Int, `object`: Any) {
        val vp = container as ViewPager
        val view = `object` as View
        vp.removeView(view)
    }
}