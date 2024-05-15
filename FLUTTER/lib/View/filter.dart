import 'package:flutter/material.dart';
import 'package:library_app/Model/library.dart';

class Filters {
  bool isWithoutReviews;
  String fromPrice;
  String toPrice;

  Filters({required this.isWithoutReviews, required this.fromPrice, required this.toPrice});
}

class FilterScreen extends StatefulWidget {
  final Library library;

  const FilterScreen(this.library, {super.key});
  
  @override
  State<StatefulWidget> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {  
  late bool isWithoutReviews = widget.library.filters!.isWithoutReviews;
  late TextEditingController fromPrice = TextEditingController();
  late TextEditingController toPrice = TextEditingController();

  @override
	Widget build(BuildContext context) {
    fromPrice.text = widget.library.filters!.fromPrice;
    toPrice.text = widget.library.filters!.toPrice;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: 
                GestureDetector(
                  child: const Icon(Icons.check),
                  onTap: () {
                    widget.library.filters!.isWithoutReviews = isWithoutReviews;
                    widget.library.filters!.fromPrice = fromPrice.text;
                    widget.library.filters!.toPrice = toPrice.text;
                    
                    Navigator.pop(context);
                  },
                ),
            )
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Price between: ",   
                  style: TextStyle(
                    fontSize: 20
                  )               
                ),
                const SizedBox(width: 10,),
                Container(
                  constraints: const BoxConstraints(maxWidth: 50),
                  child: TextField(controller: fromPrice,),
                ),
                const SizedBox(width: 10,),
                const Text(
                  "and",
                  style: TextStyle(
                    fontSize: 20
                  )
                ),
                const SizedBox(width: 10,),
                Container(
                  constraints: const BoxConstraints(maxWidth: 50),
                  child: TextField(controller: toPrice,),
                ),
                const SizedBox(width: 10,),
              ],
            ),  
            const SizedBox(height: 50,),        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Without reviews:",
                  style: TextStyle(
                    fontSize: 20
                  ) 
                ),
                Switch(
                  value: isWithoutReviews,
                  onChanged: (newValue) {
                    setState(() {
                      isWithoutReviews = isWithoutReviews ? false : true;                                          
                    });
                  }
                )
              ],
            )          
          ]
        )
      )
    );
	}
}