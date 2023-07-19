import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class ApiService {
  static Future<Map<String, dynamic>> getDailyStockData(String symbol, String time, String output) async {
     var url = Uri.parse('https://twelve-data1.p.rapidapi.com/time_series');
    var params = {
    'symbol': symbol,
    'interval': time,
    'outputsize': output,
    'format': 'json'
  };

    var headers = {
      'X-RapidAPI-Key': 'd78c92e73fmshae2ce686cb31a5ep161293jsnc692365c0c1f',
    'X-RapidAPI-Host': 'twelve-data1.p.rapidapi.com'
    };

    var response = await http.get(url.replace(queryParameters: params), headers: headers);

    if (response.statusCode == 200) {
  
      print(json.decode(response.body).toString());
      return json.decode(response.body) as Map<String, dynamic>;

    } else {
      throw Exception('Failed to fetch data');
    }
  
    
  }

  static Future<Map<String, dynamic>> getLiveStockPrice(String symbol) async {
    

var url = Uri.parse('https://realstonks.p.rapidapi.com/$symbol');
   

    var headers = {
    'X-RapidAPI-Key': 'd78c92e73fmshae2ce686cb31a5ep161293jsnc692365c0c1f',
    'X-RapidAPI-Host': 'realstonks.p.rapidapi.com'
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch data');
    }
  
   
  }


  static Future<Map<String, dynamic>> getStockNew(String symbol) async {
    var url = Uri.parse('https://seeking-alpha.p.rapidapi.com/news/v2/list-by-symbol');
    var params = {
    'id': symbol.toLowerCase(),
    'size': '3',
    'number': '1'
  };

    var headers = {
    'X-RapidAPI-Key': 'd78c92e73fmshae2ce686cb31a5ep161293jsnc692365c0c1f',
    'X-RapidAPI-Host': 'seeking-alpha.p.rapidapi.com'
    };

    var response = await http.get(url.replace(queryParameters: params), headers: headers);

    if (response.statusCode == 200) {
      final temp = json.decode(response.body) as Map<String, dynamic>;
      temp["data"][0]["symbol"] = symbol;
      temp["data"][1]["symbol"] = symbol;
      temp["data"][2]["symbol"] = symbol;
      return temp;

    } else {
      throw Exception('Failed to fetch data');
    }
  
    
  }

  




}
























