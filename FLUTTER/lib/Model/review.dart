class Review {
  String author;
  String description;

  Review({required this.author, required this.description});

  factory Review.fromJson(Map jsonMap) {
    return Review(
      author: jsonMap["email"],
      description: jsonMap["description"]
    );
  }

  Map toJson(){
    return {
      "email" : author,
      "description" : description
    };
  }
}