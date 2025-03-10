import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/crypto_provider.dart';
import '../widgets/crypto_card.dart';
import 'currency_converter.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CryptoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Crypto Tracker"),
        actions: [
          IconButton(
            icon: Icon(provider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => provider.toggleDarkMode(),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => provider.loadCryptoData(),
          ),
          IconButton(
            icon: Icon(Icons.currency_exchange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyConverterScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Crypto...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => provider.searchCrypto(value),
            ),
          ),
          DropdownButton<String>(
            value: provider.currency,
            items: ["usd", "eur", "inr", "gbp", "jpy"].map((String currency) {
              return DropdownMenuItem(value: currency, child: Text(currency.toUpperCase()));
            }).toList(),
            onChanged: (value) => provider.changeCurrency(value!),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.filteredList.length,
              itemBuilder: (context, index) {
                return CryptoCard(data: provider.filteredList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
