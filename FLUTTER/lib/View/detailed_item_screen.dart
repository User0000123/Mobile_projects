import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:library_app/Model/book.dart';
import 'package:library_app/Model/review.dart';
import 'package:library_app/Model/reviews_loader.dart';
import 'package:library_app/View/review_screen.dart';
import 'package:library_app/main.dart';

List<Function> notification = List.empty(growable: true);

class DetailedItemScreen extends StatefulWidget {
  final Book book;

  const DetailedItemScreen({super.key, required this.book});
  
  @override
  State<StatefulWidget> createState() => _DetailedItemScreenState();
}

class _DetailedItemScreenState extends State<DetailedItemScreen> {
  List<Review> reviews = List.empty();
  late Function loader;
  late bool tempVariableisliked = customUser.favourites!.contains(widget.book.id);

  @override
  void initState() {
    super.initState();
    loader = () {ReviewsLoader.loadReviews(widget.book.id).then((value) => reviews = value).whenComplete(() {if (mounted) setState(() {});});};
    loader();
    notification.add(loader);
  }

  @override
  void dispose(){
    notification.remove(loader);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),      
      body: 
        SingleChildScrollView(
          child:     
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  height: 400,              
                  child: _ImageCarousel(widget.book.images!.cast<Uint8List>()),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child:                     
                    Column(                          
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.book.rating.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 20,
                                  )
                                ),
                                const Icon(Icons.star, color: Colors.orange),
                                Text(
                                  "(${widget.book.ratingsNumber} ratings)",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  )
                                ),
                              ],
                            ),
                            Text(
                              "\$ ${widget.book.price}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            if (tempVariableisliked) {
                              tempVariableisliked = false;
                              customUser.favourites!.remove(widget.book.id);
                            } else {
                              tempVariableisliked = true;
                              customUser.favourites!.add(widget.book.id);
                            }
                            for (var element in notification) {
                              element();
                            }
                            updateUser();
                          }),
                          child:
                            Align(
                              alignment: Alignment.centerRight,
                              child: tempVariableisliked ? const Icon(Icons.favorite, color: Colors.red, size: 40,) : const Icon(Icons.favorite, size: 40)
                            ),
                        ),
                        Container (
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: 
                            Text(
                              widget.book.title,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo
                              )
                            ),
                        ),
                        Container (
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(bottom: 30),
                          child: 
                            Text(
                                widget.book.authors.join(", "),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,                                
                                  color: Colors.grey
                                )
                            ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _CommentCard(reviews[index].author, reviews[index].description)
                            );},
                        ),
                        SizedBox(width: 130, child:
                          TextButton(
                            child: const Text(
                              "Add review",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                              ),
                            ),
                            onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewScreen(book: widget.book)))
                          )
                        ),
                      ]
                    )
                  )
                ],
              ),
          )
    );
  }
}

class _CommentCard extends StatelessWidget {
  final String author;
  final String text;

  const _CommentCard(this.author, this.text);
  
  @override
  Widget build(BuildContext context) {
    return Card(    
      child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(author, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
            Text(text, style:  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),)
          ],
        ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  final List<Uint8List> images;

  const _ImageCarousel(this.images);

  @override
  State<StatefulWidget> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel>{
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.images.length,
      pageSnapping: true,
      itemBuilder:(context, index) {
        return Image.memory(widget.images[index], fit: BoxFit.fitHeight,);
      },
    );
  }

}