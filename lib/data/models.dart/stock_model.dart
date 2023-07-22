import 'package:cloud_firestore/cloud_firestore.dart';


class Stock {
  final String symbol;
  final String name;
  final String currency;
  final String exchange;
  final String micCode;
  final String country;
  final String type;

  Stock({
    required this.symbol,
    required this.name,
    required this.currency,
    required this.exchange,
    required this.micCode,
    required this.country,
    required this.type,
  });
  @override
  String toString() {
    return '$symbol';
  }
  @override
  bool operator == (Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Stock && other.name == name && other.symbol == symbol;
  }
  @override
  int get hashCode => Object.hash(symbol, name);
}

List<Stock> parsedData() {
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

  return stockList;

  },
  onError: (e) => print("Error getting document: $e"),
 
);
  return [];

  // Parse the JSON data
  

  
  
}
