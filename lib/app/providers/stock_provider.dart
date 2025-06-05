import 'package:flutter/material.dart';
import '../services/stock_service.dart';

class StockProvider extends ChangeNotifier {
  final StockService _stockService = StockService();
  List<Stock> _stocks = [];
  bool _isLoading = false;

  List<Stock> get stocks => _stocks;
  bool get isLoading => _isLoading;

  Future<void> fetchStocks() async {
    _isLoading = true;
    notifyListeners();
    _stocks = await _stockService.fetchStocks();
    _isLoading = false;
    notifyListeners();
  }
}
