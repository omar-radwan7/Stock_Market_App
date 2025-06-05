class PortfolioStock {
  final String symbol;
  final String name;
  final double price;
  final double changePercent;

  PortfolioStock({required this.symbol, required this.name, required this.price, required this.changePercent});
}

class PortfolioSummary {
  final double total;
  final double profitPercent;
  final List<PortfolioStock> stocks;

  PortfolioSummary({required this.total, required this.profitPercent, required this.stocks});
}
