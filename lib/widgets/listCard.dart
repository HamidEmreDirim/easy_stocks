import 'package:flutter/material.dart';
import 'package:stock_app/screens/stockScreen.dart';


class ListObject extends StatelessWidget {
  const ListObject({super.key, required this.symbol, required this.name , required this.currPrice, required this.miniChart});

  final String symbol;
  final String name;
  final Widget currPrice;
  final Widget miniChart;

  String truncatedText(String txt){
      return txt.length <= 9    
        ? txt
        : txt.substring(0, 9) + '...';
  }
  

  @override
  Widget build(BuildContext context) {
    return  Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => StockScreen(symbol: symbol,)));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          
                
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  symbol,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.5),
                                                ),
                                              ),
                                              Text(truncatedText(name))
                                        
                                            ],
                                          )
                                        ],
                                      ),
                                      miniChart,
                                     
                                     currPrice
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Divider(height: 1, thickness: 0.3),
                                )
                              ],
                            ),
                          );
  }
}
