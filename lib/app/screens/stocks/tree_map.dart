import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/stock_provider.dart';
import 'stock_detail_screen.dart';

class TreeMapScreen extends StatelessWidget {
  const TreeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.background,
            Theme.of(context).colorScheme.surface,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        child: Consumer<StockProvider>(
          builder: (context, stockProvider, child) {
            if (stockProvider.isLoading && stockProvider.mostActive.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (stockProvider.errorMessage != null) {
              return Center(
                child: Text(
                  'Error: ${stockProvider.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final marketMovers = stockProvider.mostActive.take(9).toList();

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Market Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Market Map',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Barlow',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: marketMovers.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                        itemBuilder: (context, index) {
                          final stock = marketMovers[index];
                          final double change =
                              (stock['changesPercentage'] as num?)
                                  ?.toDouble() ??
                              0.0;
                          final double price =
                              (stock['price'] as num?)?.toDouble() ?? 0.0;
                          final String symbol =
                              stock['symbol'] as String? ?? 'N/A';
                          final String name =
                              stock['name'] as String? ?? 'Unknown';

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => StockDetailScreen(
                                        symbol: symbol,
                                        name: name,
                                        price: price,
                                        change: change,
                                        imageUrl:
                                            'https://financialmodelingprep.com/image-stock/$symbol.png',
                                      ),
                                ),
                              );
                            },
                            child: _buildTreeMapBox(symbol, price, change),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Market Summary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Barlow',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildSummaryRow('S&P 500', '4,135.25', 1.2),
                      const SizedBox(height: 10),
                      _buildSummaryRow('NASDAQ', '12,245.67', -0.8),
                      const SizedBox(height: 10),
                      _buildSummaryRow('DOW JONES', '32,876.34', 0.5),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTreeMapBox(String symbol, double price, double change) {
    final isPositive = change >= 0;
    final color = isPositive ? const Color(0xFF3DE85F) : Colors.red;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            symbol,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w600,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String index, String value, double change) {
    final isPositive = change >= 0;
    final color = isPositive ? const Color(0xFF3DE85F) : Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          index,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Barlow',
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Barlow',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%',
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontFamily: 'Barlow',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
