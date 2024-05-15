import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/Model/book.dart';
import 'package:library_app/Model/library.dart';
import 'package:library_app/Model/review.dart';
import 'package:library_app/Model/reviews_loader.dart';
import 'package:library_app/View/detailed_item_screen.dart';

class ReviewScreen extends StatefulWidget{
  final Book book;

  const ReviewScreen({super.key, required this.book});

  @override
  State<StatefulWidget> createState() =>  _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int nSelectedStars = 1;
  TextEditingController reviewController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child:
        Scaffold(
          appBar: AppBar(),
          resizeToAvoidBottomInset: false,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _generateStarIcons(),
                ),  
                const SizedBox(height: 20,),        
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: reviewController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 18
                      ),
                      labelText: "Review text",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20)
                    ),
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  )  ,
                ),
                SizedBox(width: 130, 
                  child:
                    TextButton(
                      child: const Text(
                        "Add review",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),
                      onPressed:() async {
                        Review review = Review(author: FirebaseAuth.instance.currentUser!.email!, description: reviewController.text);
                        Book book = widget.book;
                        book.rating = ((book.rating*book.ratingsNumber) + nSelectedStars) / (book.ratingsNumber+1);
                        book.ratingsNumber++;
                        
                        Navigator.pop(context);
                        await Library.updateBook(book);
                        ReviewsLoader.sendReview(review, book);
                        for (var element in notification) { element();}
                      }                        
                    )
                ),
              ]
            )
        )
    );
  }

  List<Padding> _generateStarIcons() {
    return List<Padding>.generate(5, (index) =>
      Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => setState(() {
            nSelectedStars = index + 1;
          }),
          child: index < nSelectedStars ? const Icon(Icons.star, size: 45, color: Colors.orange) : const Icon(Icons.star, size: 45,),
        )        
      )
    );
  }
}