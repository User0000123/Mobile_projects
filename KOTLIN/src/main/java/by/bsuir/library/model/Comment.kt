package by.bsuir.library.model

class Comment(var email: String, var description: String) {
    fun toJson(): MutableMap<String, Any> {
        return mutableMapOf(
            "email" to email,
            "description" to description
        )
    }
}