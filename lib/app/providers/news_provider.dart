import 'package:flutter/material.dart';
import '../services/stock_api_service.dart';

class NewsProvider with ChangeNotifier {
  final StockApiService _apiService = StockApiService();
  List<dynamic> _newsArticles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> get newsArticles => _newsArticles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  NewsProvider() {
    fetchNews();
  }

  Future<void> fetchNews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _newsArticles = await _apiService.fetchMarketNews();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load news articles. Please try again later.';
      _newsArticles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshNews() async {
    await fetchNews();
  }
}
