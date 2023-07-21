import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/data/api_service.dart';
import 'package:stock_app/screens/stockScreen.dart';
import 'package:stock_app/widgets/listCard.dart';
import 'package:stock_app/widgets/miniChart.dart';
import '../data/stock_model.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';





class StockStream extends StatefulWidget {
  const StockStream({super.key});

  @override
  State<StockStream> createState() => _StockStreamState();
}

class _StockStreamState extends State<StockStream> {
  bool _showList = false;
  var stockList = [];



  Future  getDailyChartData(String s) async {
  
  List<double> temp = [];
  
  final data = await ApiService.getDailyStockData(s, "5min", "100");
  final int today = DateTime.now().day;

  if (DateTime.parse(data["values"][0]["datetime"]).day == today){
  for (var item in data["values"]){      
      DateTime datetime = DateTime.parse(item["datetime"]);
      if(datetime.day == today){
        temp.add(double.parse(item["close"]));
      }
  }
  }
  else{
    for (var item in data["values"]){      
      DateTime datetime = DateTime.parse(item["datetime"]);
      if(datetime.day == today -1){
        temp.add(double.parse(item["close"]));
      }

  }
  
  temp = temp.reversed.toList();
  return temp;

}
  }










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
    setState(() {
        
        _showList = true;
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
  
 
  
  Future  getRealTimeData(String symbol) async {

    Map<String, dynamic> data = await ApiService.getLiveStockPrice(symbol);

    return data;    
  }





  @override
  void initState() {
    super.initState();
    checkCondition().then((value) {
      setState(() {
        _showList = value;
      });
    });
    
  }


  







  @override
  Widget build(BuildContext context) {
    return (_showList)
        ? Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream:  FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (asyncSnapshot.hasError) {
                    return Text('Error: ${asyncSnapshot.error}');
                  } else {
                    
                    List<dynamic> userSymbolList =
                        asyncSnapshot.data!.data()["selected_stocks"];
                    List<Stock> userStockList = [];
  
                    // Perform operations on userSymbolList
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
                        onRefresh: checkCondition,
                        child: ListView.builder(
                            itemCount: userStockList.length,
                            itemBuilder: (context, i) {
                              return Dismissible(
                                key: GlobalKey(),
                                onDismissed: (direction){
                                  String tempStock = userSymbolList[i];
                                  userSymbolList.removeAt(i);
                                  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth
                                  .instance.currentUser!.uid)
                                  .update((
                                    {"selected_stocks": userSymbolList.toSet().toList()}));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Removed ${tempStock}'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          userSymbolList.insert(i, tempStock);
                                          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth
                                  .instance.currentUser!.uid)
                                  .update((
                                    {"selected_stocks": userSymbolList.toSet().toList()}));
                                          
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
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => StockScreen(symbol: userStockList[i].symbol)));
                                  },
                                  child: ListObject(
                                    
                                      symbol: userStockList[i].symbol,
                                      name: userStockList[i].name,
                                      currPrice: FutureBuilder(future: getRealTimeData(userStockList[i].symbol) , builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                          
                                          return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          FittedBox(
                                            child: Text(
                                              "\$ ${snapshot.data["price"].toString()}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          Row(
                            
                                            children: [
                                            
                                              const SizedBox(width: 8),
                                              Text( "% "+snapshot.data["change_percentage"].toString(),
                                              ),
                                            ],
                                          )
                                        ],
                                      ) ;
                                        }else{
                                          return Center(child: CircularProgressIndicator());
                                        }
                                      }
                                            ),
                                    miniChart: FutureBuilder(future: getDailyChartData(userStockList[i].symbol),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                          
                                          return MiniChart(data: snapshot.data);


                                        }else{
                                          return CircularProgressIndicator();
                                        }
                                      }),
                                    ),
                                ),
                              );
                            }),
                      ),
                    );
                  }
                })
          ],
        )
        : Center(child: CircularProgressIndicator());
  }
}



