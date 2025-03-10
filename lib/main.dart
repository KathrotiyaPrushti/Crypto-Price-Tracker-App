import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/crypto_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CryptoProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CryptoProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Tracker',
      themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
