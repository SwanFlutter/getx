import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getx/getx.dart';

GetConnect http = GetConnect();

extension CurrencyConverter on double {
  static const String baseUrl = 'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies';

  /// Convert USD to EUR
  Future<double> convertUsdToEur() async {
    final response = await http.get('$baseUrl/usd.json');

    if (response.statusCode == 200) {
      final data = json.decode(response.bodyString!);
      double conversionRate = data['usd']['eur'];
      print('Conversion Rate (USD to EUR): ${conversionRate.toStringAsFixed(2)}'); // نمایش با دو رقم اعشار
      return this * conversionRate;
    } else {
      throw Exception('Failed to load conversion rate');
    }
  }

  /// Convert EUR to USD
  Future<double> convertEurToUsd() async {
    final response = await http.get('$baseUrl/eur.json');

    if (response.statusCode == 200) {
      final data = json.decode(response.bodyString!);
      double conversionRate = data['eur']['usd'];
      print('Conversion Rate (EUR to USD): ${conversionRate.toStringAsFixed(2)}'); // نمایش با دو رقم اعشار
      return this * conversionRate;
    } else {
      throw Exception('Failed to load conversion rate');
    }
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double amountToConvert = 100.0; // مقدار پیش‌فرض برای تبدیل
  double convertedAmount = 0.0; // مقدار تبدیل شده

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Amount in EUR'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amountToConvert = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                convertedAmount = await amountToConvert.convertEurToUsd();
                setState(() {}); // بروزرسانی UI
              },
              child: Text('Convert EUR to USD'),
            ),
            Text('Converted Amount in USD: ${convertedAmount.toStringAsFixed(2)}'), // نمایش با دو رقم اعشار
          ],
        ),
      ),
    );
  }
}
