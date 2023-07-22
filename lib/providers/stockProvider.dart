import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_app/data/models.dart/stock_model.dart';
import 'package:stock_app/data/api_service.dart';


final realTimePriceProvider = FutureProvider.family((ref, String symbol) async {
  
  final data = await ApiService.getLiveStockPrice(symbol);

  return data;
});