import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:library_app/Model/book.dart';
import 'package:library_app/Model/cache_manager.dart';
import 'package:library_app/View/filter.dart';
import 'package:library_app/main.dart';

enum ResultType {
  paginated, plain
}

enum PaginationAction {
  getNextPage, getPreviousPage, stayAtCurentPage
}

class Library {
  late List<Book> _books;
  late DatabaseReference _dbLibraryReference;
  late Reference _storageReference;
  late CacheManager imagesCache;
  int currentPage;

  final int _nPageItems;
  final int _lastPage = 3;
  
  late ResultType resultType;
  late Filters? filters;

  int get booksCount => _books.length;
  int get pageSize => _nPageItems;

  Library(this._nPageItems, {this.currentPage = 1}){
    _dbLibraryReference = FirebaseDatabase
        .instance
        .refFromURL(dbUrlPath)
        .child("Library");

    _storageReference = FirebaseStorage
        .instance
        .refFromURL(sgUrlPath)
        .child("images");

    imagesCache = CacheManager(cacheUpdaterSource: _storageReference, nMinutesCacheTimeout: 30);

    _books = List.empty(growable: true);
    resultType = ResultType.paginated;
    filters = Filters(isWithoutReviews: false, fromPrice: "", toPrice: "");
  }

  Book? getBook({required int index}) {
    return _books.elementAtOrNull(index);
  }

  Future loadLibrary(PaginationAction action, {bool Function(Book)? filter}) async {
    if ((_lastPage > currentPage && action == PaginationAction.getNextPage) || 
        (currentPage > 1 && action == PaginationAction.getPreviousPage) || 
        action == PaginationAction.stayAtCurentPage) {    
      switch (action) {
        case PaginationAction.getNextPage: currentPage++;
        case PaginationAction.getPreviousPage: currentPage--;
        default:
      }
      
      Query query;
      resultType = filter == null ? ResultType.paginated : ResultType.plain;

      switch (resultType) {
        case ResultType.plain: query = _dbLibraryReference.orderByKey();
        case ResultType.paginated: query = _dbLibraryReference.orderByKey().startAt("${(currentPage - 1) * _nPageItems + 1}").limitToFirst(_nPageItems);
      }

      await query
      .get().then((value) async {     
        List<Book> tempArray = [];

        for (var jsonEncodedBook in value.children) {
          var book = Book.fromJson((jsonEncodedBook.value as Map).cast<String, dynamic>())..id = jsonEncodedBook.key!;
          if (filter != null) {
            if (filter(book)) tempArray.add(book);
          } else {
            tempArray.add(book);
          }

          book.images ??= List.empty(growable: true);
          book.images!.add(await imagesCache.get(name: book.imagesLinks[0]));      
          await loadBookImages(book);      
        }

        _books = tempArray;
      });

      return false;
    } else if (_lastPage == currentPage || currentPage == 0) {
      return true;
    }
  }

  Future loadBookImages(Book book, {Function? reloadState}) async {
    for (int i = 1; i < book.imagesLinks.length; i++) {
      book.images!.add(await imagesCache.get(name: book.imagesLinks[i]).whenComplete(() => reloadState));
    }
  }

  static Future updateBook(Book book) async{
    DatabaseReference dbBook = FirebaseDatabase.instance.refFromURL(dbUrlPath).child("Library");
    await dbBook.child(book.id).set(book.toJson());
  }
}