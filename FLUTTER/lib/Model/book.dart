import 'dart:core';


class Book{
  String id = "-1";
  String title;
  List<String> authors;
  double rating;
  int ratingsNumber;
  String description;
  double? price;
  List<String> imagesLinks;
  List<Object>? images;

  Book(this.authors, this.description, this.title, this.imagesLinks, this.price, this.rating, this.ratingsNumber);

  factory Book.fromJson(Map jsonMap){
    return Book(
      jsonMap["authors"].cast<String>(), 
      jsonMap["description"], 
      jsonMap["title"], 
      jsonMap["imagesLinks"].cast<String>(), 
      double.parse(jsonMap["price"].toString()), 
      double.parse(jsonMap["rating"].toString()), 
      jsonMap["ratingsNumber"]);
  }

  Map toJson() => { 
    "ID": id, 
    "authors": authors,
    "description" : description,
    "title" : title,
    "imagesLinks" : imagesLinks,
    "price" : price,
    "rating" : rating,
    "ratingsNumber" : ratingsNumber
  };
}