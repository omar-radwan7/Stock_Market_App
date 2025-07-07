import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/portfolio_provider.dart';
import '../../providers/stock_provider.dart';
import '../../screens/stocks/stock_detail_screen.dart';
import '../../providers/theme_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Fetch fresh data every time the homepage is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockProvider>().fetchStocks();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_showTitle) {
      setState(() => _showTitle = true);
    } else if (_scrollController.offset <= 100 && _showTitle) {
      setState(() => _showTitle = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
              ? [
                  const Color(0xFF1A1A2E),
                  const Color(0xFF16213E),
                  const Color(0xFF0F3460),
                ]
              : [
                  const Color(0xFF667EEA),
                  const Color(0xFF764BA2),
                  Colors.white,
                ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 75,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Welcome to WiseTrade',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // Theme Toggle Button
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDark 
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            color: Colors.white,
                            size: 16,
                          ),
                          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                          onPressed: () {
                            themeProvider.toggleTheme();
                          },
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Profile Button
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDark 
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Portfolio Balance Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                              ? [
                                  const Color(0xFF2D3748),
                                  const Color(0xFF1A202C),
                                ]
                              : [
                                  Colors.white,
                                  Colors.white.withOpacity(0.9),
                                ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isDark 
                                ? Colors.black.withOpacity(0.3) 
                                : Colors.grey.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: isDark 
                            ? Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              )
                            : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Portfolio Balance',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: isDark 
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.grey[600],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_upward,
                                        color: Colors.green,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '+2.4%',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Consumer<PortfolioProvider>(
                              builder: (context, provider, _) {
                                return Text(
                                  '\$${provider.balance.toStringAsFixed(2)}',
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                    color: isDark ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildBalanceDetail(
                                    context,
                                    'Today\'s Gain',
                                    '+\$156.20',
                                    Colors.green,
                                    isDark,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: isDark 
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.3),
                                ),
                                Expanded(
                                  child: _buildBalanceDetail(
                                    context,
                                    'Total Gain',
                                    '+\$1,256.00',
                                    Colors.green,
                                    isDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Market Overview Header
                      Text(
                        'Market Overview',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explore the latest market movements',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark 
                            ? Colors.white.withOpacity(0.7)
                            : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Stocks List
                      Consumer<StockProvider>(
                        builder: (context, stockProvider, child) {
                          if (stockProvider.isLoading && !stockProvider.isInitialized) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(40),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDark ? Colors.white : theme.primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (stockProvider.errorMessage != null) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: isDark 
                                    ? const Color(0xFF2D3748)
                                    : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 48,
                                      color: Colors.red.withOpacity(0.7),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      stockProvider.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: isDark ? Colors.white : Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => stockProvider.refreshData(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Combine all stocks into one list
                          final allStocks = [
                            ...stockProvider.topGainers,
                            ...stockProvider.topLosers,
                            ...stockProvider.mostActive,
                          ];

                          // Remove duplicates based on symbol
                          final uniqueStocks = allStocks.fold<List<dynamic>>(
                            [],
                            (list, stock) {
                              if (!list.any((s) => s['symbol'] == stock['symbol'])) {
                                list.add(stock);
                              }
                              return list;
                            },
                          );

                          // Shuffle the list to mix them up
                          uniqueStocks.shuffle();

                          if (uniqueStocks.isEmpty) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: isDark 
                                    ? const Color(0xFF2D3748)
                                    : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.show_chart,
                                      size: 48,
                                      color: isDark 
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.grey.withOpacity(0.7),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No stock data available at the moment.',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: isDark 
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => stockProvider.refreshData(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text('Refresh'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return _buildStockList(uniqueStocks, theme, isDark);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockList(List<dynamic> stocks, ThemeData theme, bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        final isPositive = (stock['change'] as double) >= 0;
        final chartColor = isPositive ? Colors.green : Colors.red;

        // Generate some mock chart data based on the current price
        final basePrice = (stock['price'] as double);
        final List<FlSpot> chartData = [
          FlSpot(0, basePrice * 0.98),
          FlSpot(1, basePrice * 0.99),
          FlSpot(2, basePrice * 0.97),
          FlSpot(3, basePrice * 1.01),
          FlSpot(4, basePrice),
        ];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StockDetailScreen(
                  symbol: stock['symbol'] as String,
                  name: stock['name'] as String,
                  price: stock['price'] as double,
                  change: stock['change'] as double,
                  imageUrl: 'https://financialmodelingprep.com/image-stock/${stock['symbol']}.png',
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark 
                ? const Color(0xFF2D3748)
                : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark 
                    ? Colors.black.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              border: isDark 
                ? Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  )
                : null,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: chartColor.withOpacity(0.1),
                        border: Border.all(
                          color: chartColor.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://financialmodelingprep.com/image-stock/${stock['symbol']}.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                stock['symbol'].toString().substring(0, 1),
                                style: TextStyle(
                                  color: chartColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          },
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
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stock['name'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark 
                                ? Colors.white.withOpacity(0.6)
                                : Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${(stock['price'] as double).toStringAsFixed(2)}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: chartColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${isPositive ? '+' : ''}${stock['change'].toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: chartColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 60,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 4,
                      minY: chartData.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) * 0.95,
                      maxY: chartData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.05,
                      lineBarsData: [
                        LineChartBarData(
                          spots: chartData,
                          isCurved: true,
                          color: chartColor,
                          barWidth: 3,
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
          ),
        );
      },
    );
  }

  Widget _buildBalanceDetail(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark 
                ? Colors.white.withOpacity(0.6)
                : Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}