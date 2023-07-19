import 'package:stock_app/screens/addStockPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/widgets/listView.dart';



class StocksPage extends StatelessWidget {

 

  StocksPage(
      { Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Column(
        children: [
          SizedBox(height: 15,),
          Expanded(child: StockStream()),
        ],
      );
    
  }
}