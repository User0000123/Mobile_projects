import 'package:flutter/material.dart';
import 'package:library_app/View/books_table.dart';
import 'package:library_app/View/user_profile.dart';

class NavigationScreen extends StatefulWidget {
  final List<Widget> pages = [
          BooksTable(),
          BooksTable(isFavourites: true,),
          const UserProfile()];
  
  NavigationScreen({super.key});
  
  @override
  State<NavigationScreen> createState() => _BooksNavigationBar();
}

class _BooksNavigationBar extends State<NavigationScreen> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: 
        NavigationBar(
          onDestinationSelected: (index) => {
            setState(() {
              currentPageIndex = index;
            })
          },
          selectedIndex: currentPageIndex,
          indicatorColor: const Color.fromARGB(255, 92, 103, 170),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.menu_book_rounded),
              label: "Books"
            ),
            NavigationDestination(
              icon: Icon(Icons.star), 
              label: "Favourites"
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: "User profile"
            ),
          ],
        ),
      body: IndexedStack(
        index: currentPageIndex,
        children: widget.pages,
      ),
    );
  }
}