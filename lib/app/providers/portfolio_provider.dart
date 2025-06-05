import 'package:flutter/material.dart';
import '../services/portfolio_service.dart';

class PortfolioProvider extends ChangeNotifier {
  final PortfolioService _portfolioService = PortfolioService();
  PortfolioSummary? _summary;
  bool _isLoading = false;

  PortfolioSummary? get summary => _summary;
  bool get isLoading => _isLoading;

  Future<void> fetchPortfolio() async {
    _isLoading = true;
    notifyListeners();
    _summary = await _portfolioService.fetchPortfolio();
    _isLoading = false;
    notifyListeners();
  }
} 