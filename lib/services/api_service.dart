import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class ApiService {
  static const String baseUrl = "https://api.coingecko.com/api/v3";

  // Fetch latest crypto prices
  static Future<List<Map<String, dynamic>>> fetchCryptoData({String currency = "usd"}) async {
    final response = await http.get(
      Uri.parse("$baseUrl/coins/markets?vs_currency=$currency&order=market_cap_desc&per_page=10&page=1&sparkline=true"),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }

  // Fetch exchange rate for currency conversion
  static Future<double?> getExchangeRate(String currency) async {
    try {
      final url = Uri.parse('$baseUrl/simple/price?ids=bitcoin&vs_currencies=$currency');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['bitcoin'][currency]?.toDouble();
      }
    } catch (e) {
      print("Error fetching exchange rate: $e");
    }
    return null;
  }

  // Fetch historical price data for charts
  static Future<List<Map<String, dynamic>>> getHistoricalData(String coinId, String days) async {
    final url = Uri.parse(
        "$baseUrl/coins/$coinId/market_chart?vs_currency=usd&days=$days");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(
          data['prices'].map((e) => {'time': e[0], 'price': e[1]}));
    } else {
      throw Exception("Failed to load historical data");
    }
  }

  // Real-time crypto price updates via WebSocket
  static IOWebSocketChannel getCryptoUpdates() {
    return IOWebSocketChannel.connect("wss://ws-feed.pro.coinbase.com");
  }
}
