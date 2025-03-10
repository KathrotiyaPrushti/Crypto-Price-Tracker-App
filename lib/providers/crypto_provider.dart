import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class CryptoProvider extends ChangeNotifier {
  List<Map<String, dynamic>> cryptoList = [];
  List<Map<String, dynamic>> filteredList = [];
  List<String> watchlist = [];
  String currency = "usd";
  bool isDarkMode = false;
  double exchangeRate = 1.0;

  CryptoProvider() {
    loadPreferences();
    loadCryptoData();
  }

  /// Loads user preferences (watchlist, currency, theme)
  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    watchlist = prefs.getStringList('watchlist') ?? [];
    currency = prefs.getString('currency') ?? "usd";
    isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }

  /// Fetches crypto data based on selected currency
  Future<void> loadCryptoData() async {
    cryptoList = await ApiService.fetchCryptoData(currency: currency);
    filteredList = cryptoList;
    updateExchangeRate();
    notifyListeners();
  }

  /// Searches for a cryptocurrency in the list
  void searchCrypto(String query) {
    filteredList = cryptoList.where((coin) {
      return coin['name'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }

  /// Toggles a cryptocurrency in the watchlist
  void toggleWatchlist(String coinId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (watchlist.contains(coinId)) {
      watchlist.remove(coinId);
    } else {
      watchlist.add(coinId);
    }
    prefs.setStringList('watchlist', watchlist);
    notifyListeners();
  }

  /// Updates exchange rate based on selected currency
  Future<void> updateExchangeRate() async {
    double? rate = await ApiService.getExchangeRate(currency);
    if (rate != null) {
      exchangeRate = rate;
      notifyListeners();
    }
  }

  /// Changes the currency and reloads data
  void changeCurrency(String newCurrency) async {
    currency = newCurrency;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currency', newCurrency);
    loadCryptoData();
  }

  /// Toggles dark mode
  void toggleDarkMode() async {
    isDarkMode = !isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDarkMode);
    notifyListeners();
  }
}
