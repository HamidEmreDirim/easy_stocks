import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:stock_app/data/models.dart/stock_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StockSearchBar extends StatefulWidget {
  const StockSearchBar({super.key});

  

  @override
  State<StockSearchBar> createState() => _StockSearchBarState();
}

class _StockSearchBarState extends State<StockSearchBar> {
  
  static String _displayStringForOption(Stock option) => option.symbol;
  bool _showListStock = false;
  bool _showListUser = false;
  
  List<Stock> stockList = [];
  Future<bool> checkCondition() async {
    await FirebaseFirestore.instance
        .collection("stocks")
        .doc("data")
        .get()
        .then((DocumentSnapshot doc) {
      final json = doc.data() as Map<String, dynamic>;
      var jsonData = json['data'];
      for (var item in jsonData) {
        var stock = Stock(
          symbol: item['symbol'],
          name: item['name'],
          currency: item['currency'],
          exchange: item['exchange'],
          micCode: item['mic_code'],
          country: item['country'],
          type: item['type'],
        );
        stockList.add(stock);
      }
    });
    return true;
  }

  var symbolList = [];
  Future<bool> checkCondition2() async {
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then(
      (DocumentSnapshot snapshot)  {        
        final userData = snapshot.data() as Map<String, dynamic>;
        for (var item in userData["selected_stocks"]){
          symbolList.add(item);
        }
        return symbolList; 
        }
     );
    return true;
  }




  @override
  void initState() {
    super.initState();
    checkCondition().then((value) {
      setState(() {
        _showListStock = value;
      });
    checkCondition2().then((value) {
      setState(() {
        _showListUser = value;
      });
    });
    });
  }



  @override
  Widget build(BuildContext context) {
      
      return (_showListStock && _showListUser) ? Column(
        children: [
      Autocomplete<Stock>(
      
      optionsBuilder: (TextEditingValue textEditingValue) {
        
        if (textEditingValue.text == '') {
          return  List<Stock>.empty();
        }   
        return stockList.where((Stock option) {
          return option
              .toString()
              .contains(textEditingValue.text.toUpperCase());
        });
      },
      displayStringForOption: (Stock option) => option.symbol,
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child:  Material( 
            child:  Container( 
              width: 250,
      
              child: ListView.builder(padding: EdgeInsets.all(10),itemCount: options.length,itemBuilder: (context, i){
                return Column(
                  children: [
                    GestureDetector(onTap: () {
                      
                      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(({"selected_stocks": [...symbolList, options.elementAt(i).symbol].toSet().toList()}));
                      Navigator.of(context).pop("added");

                    },child: ListTile(leading: Icon(Icons.currency_exchange), title: Text(options.elementAt(i).symbol), subtitle: Text(options.elementAt(i).name,))),
                    Divider(height: 0,)
                  ],
                );
              }),
            ),
          ),
        );
      } ,

      
    )
                
        ],
        
      ): CircularProgressIndicator();
    
    
    }
}