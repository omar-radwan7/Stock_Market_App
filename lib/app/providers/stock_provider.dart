import 'package:flutter/material.dart';
import '../services/stock_api_service.dart';

class StockProvider with ChangeNotifier {
  final StockApiService _apiService = StockApiService();

  List<dynamic> _topGainers = [];
  List<dynamic> _topLosers = [];
  List<dynamic> _mostActive = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> get topGainers => _topGainers;
  List<dynamic> get topLosers => _topLosers;
  List<dynamic> get mostActive => _mostActive;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  StockProvider() {
    // Test connection and fetch data on initialization
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final bool isConnected = await _apiService.testConnection();
      if (!isConnected) {
        _errorMessage =
            'Could not connect to the stock market API. Please check your internet connection and try again.';
        notifyListeners();
        return;
      }
      await fetchStocks();
    } catch (e) {
      print('Error initializing data: $e');
      _errorMessage = 'Failed to initialize stock data. Please try again.';
      notifyListeners();
    }
  }

  Future<void> fetchStocks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch all data in parallel
      final results = await Future.wait([
        _apiService.fetchTopGainers(),
        _apiService.fetchTopLosers(),
        _apiService.fetchMostActive(),
      ]);

      // Update state with results
      _topGainers = _transformStockData(results[0]);
      _topLosers = _transformStockData(results[1]);
      _mostActive = _transformStockData(results[2]);

      _errorMessage = null;
    } catch (e) {
      print('Error fetching stock data: $e'); // Debug log
      _errorMessage = 'Failed to load stock data. Please try again later.';
      _topGainers = [];
      _topLosers = [];
      _mostActive = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<dynamic> _transformStockData(List<dynamic> data) {
    return data.map((stock) {
      // Ensure all required fields are present with proper types
      return {
        'symbol': stock['symbol'] as String? ?? 'N/A',
        'name': stock['name'] as String? ?? 'Unknown',
        'price': (stock['price'] as num?)?.toDouble() ?? 0.0,
        'changesPercentage':
            (stock['changesPercentage'] as num?)?.toDouble() ?? 0.0,
        'change': (stock['change'] as num?)?.toDouble() ?? 0.0,
        'dayLow': (stock['dayLow'] as num?)?.toDouble() ?? 0.0,
        'dayHigh': (stock['dayHigh'] as num?)?.toDouble() ?? 0.0,
        'yearHigh': (stock['yearHigh'] as num?)?.toDouble() ?? 0.0,
        'yearLow': (stock['yearLow'] as num?)?.toDouble() ?? 0.0,
        'marketCap': (stock['marketCap'] as num?)?.toDouble() ?? 0.0,
        'volume': (stock['volume'] as num?)?.toDouble() ?? 0.0,
        'avgVolume': (stock['avgVolume'] as num?)?.toDouble() ?? 0.0,
      };
    }).toList();
  }
}
