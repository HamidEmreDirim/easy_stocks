import 'package:flutter/material.dart';
import 'package:stock_app/widgets/stockChart.dart';

enum TimePart { oneM, fiveM, oneH, fourH, oneD }

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key, required this.symbol}) : super(key: key);
  final String symbol;

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  TimePart calendarView = TimePart.oneD;
  String time = "";
  Key chartKey = UniqueKey(); // Create a key for the chart widget

  @override
  void initState() {
    setState(() {
      time = "1day";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              
              children: [
                
                SizedBox(height: 120,),
                CandleChart(
                  key: chartKey, // Assign the key to the chart widget
                  symbol: widget.symbol,
                  time: time,
                ),
                SizedBox(height: 10),
                SegmentedButton<TimePart>(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.black38),
                  ),
                  segments: const <ButtonSegment<TimePart>>[
                    ButtonSegment<TimePart>(
                      value: TimePart.oneM,
                      label: Text('1M'),
                    ),
                    ButtonSegment<TimePart>(
                      value: TimePart.fiveM,
                      label: Text('5M'),
                    ),
                    ButtonSegment<TimePart>(
                      value: TimePart.oneH,
                      label: Text('1H'),
                    ),
                    ButtonSegment<TimePart>(
                      value: TimePart.fourH,
                      label: Text('4H'),
                    ),
                    ButtonSegment<TimePart>(
                      value: TimePart.oneD,
                      label: Text('24H'),
                    ),
                  ],
                  selected: <TimePart>{calendarView},
                  onSelectionChanged: (Set<TimePart> newSelection) {
                    setState(() {
                      calendarView = newSelection.first;
                      time = _getTimeFromSelection(newSelection.first);
                      chartKey = UniqueKey(); // Assign a new key to trigger a rebuild of the chart
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeFromSelection(TimePart timePart) {
    switch (timePart) {
      case TimePart.oneM:
        return "1min";
      case TimePart.fiveM:
        return "5min";
      case TimePart.oneH:
        return "1h";
      case TimePart.fourH:
        return "4h";
      case TimePart.oneD:
        return "1day";
      default:
        return "";
    }
  }
}
