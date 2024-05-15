import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:library_app/Model/book.dart';
import 'package:library_app/Model/library.dart';
import 'package:library_app/View/detailed_item_screen.dart';
import 'package:library_app/View/filter.dart';
import 'package:library_app/main.dart';

class BooksTable extends StatefulWidget {  
  final Library library = Library(10);
  final bool isFavourites;

  BooksTable({super.key, this.isFavourites = false});
  
  @override
  State<StatefulWidget> createState() => _BooksListView();
}

class _BooksListView extends State<BooksTable> {
  PaginationScrollController paginationScrollController = PaginationScrollController();
  late Function loader;

  @override
  void initState() {
    paginationScrollController.init(loadAction: widget.library.loadLibrary, updateAction: () {if (mounted) setState(() {});}, library: widget.library);
    loader = () {
        widget.library.loadLibrary(PaginationAction.stayAtCurentPage, 
      filter: widget.isFavourites ? (book) => customUser.favourites!.contains(book.id) : null).whenComplete(() {if (mounted) setState(() {});});
    };
    loader();
    notification.add(loader);
    super.initState();
  }

  @override
  void dispose() {
    paginationScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.isFavourites ? const SizedBox(width: 0, height: 20,) : _SearchAndFilterContainer(() {if (mounted) setState(() {});}, widget.library),
        _BooksTableContainer(widget, paginationScrollController),
      ]
    );
  }
}

class _SearchAndFilterContainer extends StatelessWidget {
  final Function updateList;
  final Library library;

  const _SearchAndFilterContainer(this.updateList, this.library);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 35, left: 10, right: 10, bottom: 10),
      child: Stack(
        children: [
          SearchBar(
            padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
            onSubmitted: (searchRequest) => 
              library.loadLibrary(PaginationAction.stayAtCurentPage, filter: (book) => book.title.toLowerCase().contains(searchRequest.toLowerCase()))
              .whenComplete(() => updateList()),
            leading: const Icon(Icons.search),
          ),
          Align(
            alignment: const FractionalOffset(0.9, 0.8),
            child:
              SizedBox(width: 75, height: 50, child:
                TextButton(
                  child: const Text(
                    "Filter",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.indigo,
                    ),
                  ),
                  onPressed:() async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => FilterScreen(library),));

                    if (library.filters != null) {
                      double fromPrice = double.tryParse(library.filters!.fromPrice) ?? 0;
                      double toPrice = double.tryParse(library.filters!.toPrice) ?? 999;

                      library.loadLibrary(PaginationAction.stayAtCurentPage, filter: (book) {
                        bool result = true;

                        result = result && (book.price! >= fromPrice && book.price! <= toPrice);

                        if (library.filters!.isWithoutReviews){
                          result = result && book.ratingsNumber == 0;
                        }

                        return result;
                      }).whenComplete(() => updateList());
                    }
                  }
                )
              ),
          )
        ]
      ), 
    );
  }
}

class _BooksTableContainer extends StatelessWidget {
  final BooksTable widget;
  final PaginationScrollController scrollController;

  const _BooksTableContainer(this.widget, this.scrollController);
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: 
        ListView.builder(
          controller: scrollController.controller,
          padding: const EdgeInsets.symmetric(horizontal: 10),              
          itemCount: widget.library.booksCount,
          itemBuilder: (BuildContext context, int index) {        
            return _BookPreviewListItem(widget.library.getBook(index: index)!);
          },
      ),
    );
  }
}

class PaginationScrollController {
  late ScrollController controller;
  late Function loadAction;
  late Function updateAction;
  late Library library;
  bool isLoading = false;

  void init({required Function loadAction, required Function updateAction, required Library library}) {
    controller = ScrollController()..addListener(scrollListener);
    this.loadAction = loadAction;
    this.updateAction = updateAction;
    this.library = library;
  }

  void dispose() {
    controller.removeListener(scrollListener);
    controller.dispose();
  }

  void scrollListener() async {
    if (library.resultType == ResultType.paginated && (controller.offset == controller.position.maxScrollExtent || controller.offset == 0) && !isLoading) {
      isLoading = true;
      await loadAction(controller.offset == 0 ? PaginationAction.getPreviousPage : PaginationAction.getNextPage).then((shouldStop) {
        isLoading = false;            
        if (shouldStop == false) {
          controller.animateTo(controller.offset == 0 ? controller.position.maxScrollExtent - 5 : 5, duration: const Duration(milliseconds: 500), curve: Curves.decelerate);       
          updateAction();
        }
      }
      );
    }
  }
}

class _BookPreviewListItem extends StatelessWidget {
  final Book book;

  const _BookPreviewListItem(this.book);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(child:
      Card (   
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),            
        child: 
          SizedBox(
            height: 220,
            child: 
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: 
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [                       
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: 
                                  Text(
                                    book.title, 
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,                       
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,                                                      
                                    ),
                                  ),
                              ),                     
                              Text(
                                book.authors.join(", "),  
                                overflow: TextOverflow.ellipsis,                      
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,                                                                                  
                                ),
                                maxLines: 2,
                              ),  
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child:                 
                                  Text(
                                    "\$ ${book.price}",                                
                                    style: const TextStyle(
                                      fontSize: 18,                                
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,                                                                                  
                                    ),
                                  ),
                              ),
                              Expanded(
                                child: 
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child:
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            book.rating.toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontSize: 17
                                            )
                                          ),
                                          const Icon(Icons.star, color: Colors.orange,)
                                        ],
                                      )                              
                                  )
                              )
                            ],
                          ),
                      )        
                  ),
                  Expanded(
                    flex: 1,
                    child: Image.memory(book.images![0] as Uint8List, fit: BoxFit.fitHeight,),
                  )
                ]
              ),
          )
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedItemScreen(book: book,)))
    );
  }

}