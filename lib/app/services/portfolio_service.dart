import '../models/portfolio_model.dart';

class PortfolioService {
  Future<PortfolioSummary> fetchPortfolio() async {
    await Future.delayed(Duration(seconds: 1));
    return PortfolioSummary(
      total: 6879.00,
      profitPercent: 62.38,
      stocks: [
        PortfolioStock(symbol: 'AAPL', name: 'Apple, Inc', price: 459.67, changePercent: 0.56),
        PortfolioStock(symbol: 'AMZN', name: 'Amazon.com, Inc', price: 125.89, changePercent: 0.63),
        PortfolioStock(symbol: 'NKE', name: 'NIKE, Inc', price: 230.08, changePercent: 0.53),
        PortfolioStock(symbol: 'PYPL', name: 'Paypal Holdings, Inc', price: 177.21, changePercent: 0.33),
      ],
    );
  }
} 