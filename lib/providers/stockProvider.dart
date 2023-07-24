import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/api_service.dart';


Future<List<double>> getDailyChartData(String s) async {

  List<double> temp = [];

  final data = await ApiService.getDailyStockData(s, "5min", "100");
  final int day = DateTime.parse(data["values"][0]["datetime"]).day;


  for (var item in data["values"]){      
      DateTime datetime = DateTime.parse(item["datetime"]);
      
      if(datetime.day == day){
        temp.add(double.parse(item["close"]));
      }
  }

  temp = temp.reversed.toList();
  return temp;


}

Future<Map<String, dynamic>>  getRealTimeData(String symbol) async {

  Map<String, dynamic> data = await ApiService.getLiveStockPrice(symbol);

  return data;    
}



final symbolStreamProvider = StreamProvider<DocumentSnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
});


final dailyChartDataProvider = FutureProvider.family<List<dynamic>, String>((ref, symbol) async {
  return getDailyChartData(symbol);
});

final realTimeDataProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, symbol) async {
  return getRealTimeData(symbol);
});

