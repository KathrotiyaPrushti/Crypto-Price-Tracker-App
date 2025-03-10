import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/price_chart.dart';

class CoinDetailScreen extends StatefulWidget {
  final String coinId;
  final String coinName;

  CoinDetailScreen({required this.coinId, required this.coinName});

  @override
  _CoinDetailScreenState createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  String selectedTimeframe = "1D";
  List<Map<String, dynamic>> historicalData = [];

  @override
  void initState() {
    super.initState();
    fetchHistoricalData();
  }

  void fetchHistoricalData() async {
    String days = selectedTimeframe == "1D"
        ? "1"
        : selectedTimeframe == "1W"
            ? "7"
            : selectedTimeframe == "1M"
                ? "30"
                : "365";

    final data = await ApiService.getHistoricalData(widget.coinId, days);
    setState(() {
      historicalData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.coinName)),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedTimeframe,
            items: ["1D", "1W", "1M", "1Y"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedTimeframe = value!;
                fetchHistoricalData();
              });
            },
          ),
          Expanded(
            child: historicalData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : PriceChart(historicalData: historicalData),
          ),
        ],
      ),
    );
  }
}
