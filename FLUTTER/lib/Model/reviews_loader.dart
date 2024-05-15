import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:library_app/Model/book.dart';
import 'package:library_app/Model/review.dart';
import 'package:library_app/main.dart';

class ReviewsLoader {
  static final DatabaseReference _databaseReference = FirebaseDatabase.instance.refFromURL(dbUrlPath).child("Reviews");

  static Future<List<Review>> loadReviews(String id) async {
    List<Review> reviews = List.empty(growable: true);

    await _databaseReference.child(id).get().then((value) {
      for (var jsonEncodedReview in value.children) {
        reviews.add(Review.fromJson(jsonEncodedReview.value as Map));
      }
    });

    return reviews;
  }

  static Future sendReview(Review review, Book book) async {
    await _databaseReference.child(book.id).push().set(review.toJson());
  }
}