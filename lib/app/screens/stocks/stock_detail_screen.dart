import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StockDetailScreen extends StatefulWidget {
  final String symbol;
  final String name;
  final double price;
  final double change;
  final String? imageUrl;

  const StockDetailScreen({
    super.key,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    this.imageUrl,
  });

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  int _selectedTimeRange = 0;

  @override
  Widget build(BuildContext context) {
    final bool isPositive = widget.change >= 0;
    final Color changeColor = isPositive ? const Color(0xFF3DE85F) : Colors.red;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.symbol,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'Barlow',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    fontFamily: 'Barlow',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${widget.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontFamily: 'Barlow',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${isPositive ? '+' : ''}${widget.change.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 20,
                        fontFamily: 'Barlow',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(height: 250, child: LineChart(_mainChart(isPositive))),
                const SizedBox(height: 20),
                _buildTimeRangeSelector(),
                const SizedBox(height: 40),
                Text(
                  'Key Stats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildKeyStatsGrid(),
                const SizedBox(height: 40),
                _buildRangeIndicator('Day\'s Range', '123.85', '126.16', 0.6),
                const SizedBox(height: 30),
                _buildRangeIndicator('52wk Range', '75.05', '145.02', 0.8),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    final timeRanges = ['1D', '1W', '1M', '6M', '1Y', 'All'];
    return Center(
      child: CupertinoSlidingSegmentedControl<int>(
        backgroundColor: Colors.black.withOpacity(0.2),
        thumbColor: Theme.of(context).primaryColor,
        groupValue: _selectedTimeRange,
        onValueChanged: (int? value) {
          if (value != null) {
            setState(() {
              _selectedTimeRange = value;
            });
          }
        },
        children: {
          for (var i = 0; i < timeRanges.length; i++)
            i: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                timeRanges[i],
                style: TextStyle(
                  color:
                      _selectedTimeRange == i ? Colors.white : Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        },
      ),
    );
  }

  Widget _buildKeyStatsGrid() {
    final stats = {
      'Volume': '75.16M',
      'Avg. Volume': '71.52M',
      'Market Cap': '2.10T',
      'Dividend Yield': '0.70%',
      'P/E Ratio': '28.5',
      'EPS': '5.12',
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        final key = stats.keys.elementAt(index);
        final value = stats.values.elementAt(index);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                key,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRangeIndicator(
    String label,
    String start,
    String end,
    double value,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(start, style: TextStyle(color: Colors.white70, fontSize: 14)),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(end, style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData _mainChart(bool isPositive) {
    final Color chartColor = isPositive ? const Color(0xFF3DE85F) : Colors.red;

    List<FlSpot> spots = const [
      FlSpot(0, 3),
      FlSpot(1, 2),
      FlSpot(2, 5),
      FlSpot(3, 3.1),
      FlSpot(4, 4),
      FlSpot(5, 3),
      FlSpot(6, 4),
      FlSpot(7, 3.5),
      FlSpot(8, 4.5),
      FlSpot(9, 4),
    ];

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: chartColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                chartColor.withOpacity(0.3),
                chartColor.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}
