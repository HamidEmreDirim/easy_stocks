import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_app/data/api_service.dart';
import 'package:stock_app/screens/stockScreen.dart';
import 'package:stock_app/widgets/listCard.dart';
import 'package:stock_app/widgets/miniChart.dart';
import '../data/models.dart/stock_model.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../providers/stockProvider.dart';





class StockStream extends ConsumerStatefulWidget {
  const StockStream({super.key});

  @override
  ConsumerState<StockStream> createState() => _StockStreamState();
}

class _StockStreamState extends ConsumerState<StockStream> {
  bool _showList = false;
  var stockList = [];


  Future<bool> getAllStocks() async {
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
    setState(() {
        
        _showList = true;
      });
    return true;
  }

  
  var symbolList = [];
  Future<bool> getSelectedStocks() async {
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
    getAllStocks().then((value) {
      setState(() {
        _showList = value;
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(symbolStreamProvider);
    

   return (_showList)
    ? Column(
        children: [
          
          snapshotAsync.when(
            data: (snapshot) {
              if (snapshot.exists) {
                Map<String, dynamic>? data =
                    snapshot.data() as Map<String, dynamic>?;

                if (data != null) {
                  List<dynamic> userSymbolList = data["selected_stocks"];
                  List<Stock> userStockList = []; // Your Stock list conversion here

                  for (dynamic item in userSymbolList) {
                    Stock? temp = stockList.firstWhere(
                      (element) => element.symbol == item.toString(),
                      orElse: () => null,
                    );

                    if (temp != null) {
                      userStockList.add(temp);
                    }
                  }

                  return Expanded(
                    child: LiquidPullToRefresh(
                      color: Colors.white,
                      backgroundColor: Colors.black26,
                      animSpeedFactor: 6,
                      onRefresh: getAllStocks,
                      child: ListView.builder(
                        itemCount: userStockList.length,
                        itemBuilder: (context, i) {
                          final listKey = Key(i.toString());
                          return Dismissible(
                            key: listKey,
                            onDismissed: (direction) {
                              String tempStock = userSymbolList[i];
                              userSymbolList.removeAt(i);
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "selected_stocks": userSymbolList.toSet().toList()
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Removed ${tempStock}'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      userSymbolList.insert(i, tempStock);
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        "selected_stocks": userSymbolList.toSet().toList()
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            direction: DismissDirection.horizontal,
                            dragStartBehavior: DragStartBehavior.start,
                            movementDuration: const Duration(milliseconds: 200),
                            resizeDuration: const Duration(milliseconds: 1000),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StockScreen(symbol: userStockList[i].symbol)));
                              },
                              child: ListObject(
                                symbol: userStockList[i].symbol,
                                name: userStockList[i].name,
                                currPrice: ref.watch(realTimeDataProvider(userStockList[i].symbol)).when(data: 
                                (realTimeData) {
                                        if (realTimeData != null) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              FittedBox(
                                                child: Text(
                                                  "\$ ${realTimeData["price"].toString()}",
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 15),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "% " + realTimeData["change_percentage"].toString(),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        } else {
                                          return Center(child: CircularProgressIndicator());
                                        }
                                      }, error: (error, stack) => Text('Error: $error'), loading: () => CircularProgressIndicator()),



                                miniChart: ref.watch(dailyChartDataProvider(userStockList[i].symbol)).when(data: 
                                (dailyChartData) {
                                        if (dailyChartData != null) {
                                          return MiniChart(data: dailyChartData.cast<double>());
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      }, error: (error, stack) => Text('Error: $error'), loading: () => CircularProgressIndicator())
                                      
                                    ),
                              ),
                            );
                          
                        },
                      ),
                    ),
                  );
                }
                // Handle the case when data is null or "selected_stocks" is not available
                return Text("No data available");
              } else {
                // Document does not exist
                return Text("Document does not exist");
              }
            },
            loading: () => Center(child:CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
          ),
          // End of snapshotAsync.when() method
        ],
      )
    : Center(child: CircularProgressIndicator());

  }


}