import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_app/data/models.dart/stock_model.dart';





class DataBase {
  static Future<List<Stock>> _get_stocks() async {
  var stockList = <Stock>[];
  var db = FirebaseFirestore.instance;
  final docRef = db.collection("stocks").doc("data");
  docRef.get().then(
  (DocumentSnapshot doc) {
    final json= doc.data() as Map<String, dynamic>;
    // ...
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
  }
  );
  return stockList;  
}
  static Future<List<String>>  _get_users_preference() async {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    var db = FirebaseFirestore.instance;
    final docRef = db.collection("users").doc(uid);
    docRef.get().then(
  (DocumentSnapshot doc) {
    final json= doc.data() as Map<String, dynamic>;
    var selected_stocks = json['user_preferences']['exchanges'];
    return selected_stocks;
  }
    );
    return [];
  }
  static Future<List<Stock>>   selected_stocks() async {
    var  selected;
    var stock_data = await _get_stocks();
    var users_stock = await _get_users_preference();

    

    for (int i = 0; i < users_stock.length; i++){
        for (int j=0; j<stock_data.length; j++){
          if (users_stock[i]  == stock_data[j].symbol){
            selected.add(stock_data[j]);
          }
        }
    }
    
    return selected;
  }

  


}

