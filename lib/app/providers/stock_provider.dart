import 'package:flutter/material.dart';
import '../services/stock_api_service.dart';

class StockProvider with ChangeNotifier {
  final StockApiService _apiService = StockApiService();

  List<dynamic> _topGainers = [];
  List<dynamic> _topLosers = [];
  List<dynamic> _mostActive = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  List<dynamic> get topGainers => _topGainers;
  List<dynamic> get topLosers => _topLosers;
  List<dynamic> get mostActive => _mostActive;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  StockProvider() {
    print('StockProvider initialized'); // Debug log
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (_isInitialized) {
      print('Provider already initialized, skipping'); // Debug log
      return;
    }

    print('Starting provider initialization'); // Debug log
    try {
      final bool isConnected = await _apiService.testConnection();
      print('API connection test result: $isConnected'); // Debug log

      if (!isConnected) {
        _errorMessage =
            'Could not connect to the stock market API. Please check your internet connection and try again.';
        notifyListeners();
        return;
      }

      await fetchStocks();
      _isInitialized = true;
      print('Provider initialization complete'); // Debug log
    } catch (e) {
      print('Error initializing provider: $e'); // Debug log
      _errorMessage = 'Failed to initialize stock data. Please try again.';
      notifyListeners();
    }
  }

  Future<void> fetchStocks() async {
    print('Starting to fetch stocks'); // Debug log
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

      print('All API calls completed successfully'); // Debug log

      // Update state with results
      _topGainers = _transformStockData(results[0]);
      _topLosers = _transformStockData(results[1]);
      _mostActive = _transformStockData(results[2]);

      print(
        'Data transformation complete. Counts - Gainers: ${_topGainers.length}, Losers: ${_topLosers.length}, Active: ${_mostActive.length}',
      ); // Debug log

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
    try {
      return data.map((stock) {
        // Ensure all required fields are present with proper types
        final transformed = {
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
        print(
          'Transformed stock data for ${transformed['symbol']}: $transformed',
        ); // Debug log
        return transformed;
      }).toList();
    } catch (e) {
      print('Error transforming stock data: $e'); // Debug log
      return [];
    }
  }

  // Method to manually refresh data
  Future<void> refreshData() async {
    print('Manual refresh requested'); // Debug log
    await fetchStocks();
  }
}
