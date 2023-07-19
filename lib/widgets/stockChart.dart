import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:stock_app/data/api_service.dart';

enum Calendar { day, week, month }

class CandleChart extends StatefulWidget {
  const CandleChart({super.key, required this.symbol, required this.time});
  
  final symbol;
  final time;

  @override
  State<CandleChart> createState() => _CandleChartState();
}

class _CandleChartState extends State<CandleChart> {
  List<Candle> candles = [];
  bool themeIsDark = false;
  bool showChart = false;

  @override
  void initState() {
    getDailyChartData(widget.symbol, widget.time).then((value) {
      setState(() {
        candles = value;
        showChart = true;
      });
    });
    super.initState();
  }

  


  Future  getDailyChartData(String s, String t) async {
  
  final List<Candle> temp = [];
  final data = await ApiService.getDailyStockData(s, t,"200");

  for (var item in data["values"]){
      temp.add(Candle(date: DateTime.parse(item["datetime"]), high: double.parse(item["high"]), low: double.parse(item["low"]), open: double.parse(item["open"]), close: double.parse(item["close"]), volume: double.parse(item["volume"])));
  }

  return temp;

}

  Calendar calendarView = Calendar.day;
  @override
  Widget build(BuildContext context) {
    return showChart ? Center(
          child: Container(
            
            height: 400,
            width: 480,
            child: Candlesticks(
              candles: candles,
              
            ),
          )): CircularProgressIndicator();

  

  }
}