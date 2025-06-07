import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockList extends StatelessWidget {
  const StockList({super.key});

  @override
  Widget build(BuildContext context) {
    final stocks = [
      {
        'symbol': 'AAPL',
        'name': 'Apple Inc.',
        'price': 459.67,
        'change': 0.56,
        'image': 'https://placehold.co/24x24',
        'chartData': [
          FlSpot(0, 450),
          FlSpot(1, 438),
          FlSpot(2, 445),
          FlSpot(3, 452),
          FlSpot(4, 459.67),
        ],
        'isPositive': true,
      },
      {
        'symbol': 'AMZN',
        'name': 'Amazon.com Inc.',
        'price': 125.89,
        'change': 0.63,
        'image': 'https://placehold.co/24x24',
        'chartData': [
          FlSpot(0, 115),
          FlSpot(1, 118),
          FlSpot(2, 122),
          FlSpot(3, 124),
          FlSpot(4, 125.89),
        ],
        'isPositive': true,
      },
      {
        'symbol': 'TSLA',
        'name': 'Tesla Inc.',
        'price': 230.08,
        'change': -1.53,
        'image': 'https://placehold.co/24x24',
        'chartData': [
          FlSpot(0, 240),
          FlSpot(1, 235),
          FlSpot(2, 238),
          FlSpot(3, 232),
          FlSpot(4, 230.08),
        ],
        'isPositive': false,
      },
    ];

    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        final isPositive = stock['isPositive'] as bool;
        final chartColor = isPositive ? const Color(0xFF3DE85F) : Colors.red;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(stock['image'] as String),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stock['symbol'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          stock['name'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${(stock['price'] as double).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: chartColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${(stock['change'] as double).isNegative ? '' : '+'}${(stock['change'] as double).toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: chartColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 4,
                    minY:
                        (stock['chartData'] as List<FlSpot>)
                            .map((spot) => spot.y)
                            .reduce((a, b) => a < b ? a : b) *
                        0.95,
                    maxY:
                        (stock['chartData'] as List<FlSpot>)
                            .map((spot) => spot.y)
                            .reduce((a, b) => a > b ? a : b) *
                        1.05,
                    lineBarsData: [
                      LineChartBarData(
                        spots: stock['chartData'] as List<FlSpot>,
                        isCurved: true,
                        color: chartColor,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: chartColor.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
