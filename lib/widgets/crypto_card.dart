import 'package:flutter/material.dart';
import '../screens/coin_detail_screen.dart';

class CryptoCard extends StatelessWidget {
  final Map<String, dynamic> data;

  CryptoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(data['image'], width: 40),
        title: Text(data['name']),
        subtitle: Text("\$${data['current_price']}"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoinDetailScreen(
                coinId: data['id'], // ✅ Correct parameter
                coinName: data['name'], // ✅ Correct parameter
              ),
            ),
          );
        },
      ),
    );
  }
}
