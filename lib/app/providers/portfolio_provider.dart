import 'package:flutter/material.dart';
import '../models/portfolio_model.dart';
import '../services/portfolio_service.dart' hide PortfolioStock, PortfolioSummary;

class PortfolioProvider extends ChangeNotifier {
  final PortfolioService _portfolioService = PortfolioService();
  PortfolioSummary? _summary;
  bool _isLoading = false;
  double _balance = 10000.0;
  final List<PortfolioStock> _stocks = [];

  PortfolioSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  double get balance => _balance;
  List<PortfolioStock> get stocks => List.unmodifiable(_stocks);

  Future<void> fetchPortfolio() async {
    _isLoading = true;
    notifyListeners();
    _summary = await _portfolioService.fetchPortfolio() as PortfolioSummary?;
    _isLoading = false;
    notifyListeners();
  }

  void buyStock(PortfolioStock stock) {
    if (_balance >= stock.price) {
      _stocks.add(stock);
      _balance -= stock.price;
      notifyListeners();
    }
  }

  void sellStock(PortfolioStock stock) {
    if (_stocks.contains(stock)) {
      _stocks.remove(stock);
      _balance += stock.price;
      notifyListeners();
    }
  }
} 