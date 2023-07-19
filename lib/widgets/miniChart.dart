import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';

class MiniChart extends StatelessWidget {
  const MiniChart({super.key, required this.data});
  
  final List<double> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                    width: 100,
                    height: 60,
                    child: Sparkline(
                      data: data,
                      lineWidth: 2.0,
                      lineColor: Colors.black38,
                      fillMode: FillMode.below,
                      fillGradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.7],
                          colors: data.first <= data.last       
                                                  ? [
                                                      Colors.green,
                                                      Colors.green.shade100
                                                    ]
                                                  : [
                                                      Colors.red,
                                                      Colors.red.shade100
                                                    ]
                                
                              ),
                    ),
                  );
  }
}