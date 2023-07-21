import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:stock_app/widgets/autoCompleteSearch.dart';



class AddStockPage extends StatelessWidget {
  const AddStockPage({super.key});

  

  @override
  
  Widget build(BuildContext context) {
    

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
            
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 75,
            
            actions: [Container(child: StockSearchBar(), width: 250,),
            SizedBox(width: 60,)
          ],
            ),
      body: SafeArea(child: 
      UnDraw(
  color: const Color.fromARGB(255, 131, 233, 184),
  illustration: UnDrawIllustration.investing,
  placeholder: Text("Illustration is loading..."), //optional, default is the CircularProgressIndicator().
  errorWidget: Icon(Icons.error_outline, color: Colors.red, size: 50), //optional, default is the Text('Could not load illustration!').


),),
      
           
    );     
  }
}
  
