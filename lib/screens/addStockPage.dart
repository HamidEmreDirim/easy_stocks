import 'package:flutter/material.dart';

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
            toolbarHeight: 65,
),
            body:  SafeArea(
        child: Center(
          child: Column(
            children: [          
            Container(child: StockSearchBar(), width: 350,),
            ],
          ),
        ),
      ),
    );     
  }
}
  
