import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCurrency = "usd";
  double _convertedAmount = 0.0;
  bool _isLoading = false;

  Future<void> _convertCurrency() async {
    setState(() {
      _isLoading = true;
    });

    double? rate = await ApiService.getExchangeRate(_selectedCurrency);
    if (rate != null) {
      setState(() {
        _convertedAmount = (double.tryParse(_amountController.text) ?? 0) * rate;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch exchange rate")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Currency Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter amount in Bitcoin",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedCurrency,
              items: ["usd", "eur", "inr", "gbp", "jpy"].map((String currency) {
                return DropdownMenuItem(value: currency, child: Text(currency.toUpperCase()));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: Text("Convert"),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Text(
                    "Converted Amount: $_convertedAmount $_selectedCurrency",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ],
        ),
      ),
    );
  }
}
