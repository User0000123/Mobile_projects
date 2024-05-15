package by.bsuir.library.model

class Book(var title: String, var authors: List<String>, var rating: Double, var ratingsNumber: Int,
    var description: String, var price: Double?, var imagesLinks: List<String>) {
    var ID: String = "-1"
    @Transient var images: MutableList<ByteArray>? = null

    fun toJson(): Map<String, Any>{
        return mutableMapOf(
            "ID" to ID,
            "authors" to authors,
            "title" to title,
            "description" to description,
            "imagesLinks" to imagesLinks,
            "price" to price!!,
            "rating" to rating,
            "ratingsNumber" to ratingsNumber,
        )
    }
}