class Stock {
  final String symbol;
  final String name;
  final double price;
  final double changePercent;

  Stock({required this.symbol, required this.name, required this.price, required this.changePercent});
}

class StockService {
  // TODO: Move API key to a secure configuration file
  final String apiKey = const String.fromEnvironment('STOCK_API_KEY', defaultValue: '');

  Future<List<Stock>> fetchStocks() async {
    // TODO: Use the API key to fetch real data from an API
    await Future.delayed(Duration(seconds: 1));
    return [
      Stock(symbol: 'AAPL', name: 'Apple, Inc', price: 459.67, changePercent: 0.56),
      Stock(symbol: 'AMZN', name: 'Amazon.com, Inc', price: 125.89, changePercent: 0.63),
      Stock(symbol: 'NKE', name: 'NIKE, Inc', price: 230.08, changePercent: 0.53),
      Stock(symbol: 'PYPL', name: 'Paypal Holdings, Inc', price: 177.21, changePercent: 0.33),
    ];
  }
}
