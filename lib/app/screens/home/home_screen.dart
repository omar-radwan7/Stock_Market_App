import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock_market_app/app/screens/profile/profile.dart';
import '../../providers/auth_provider.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockProvider>().fetchStocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Sleek Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning,',
                            style: TextStyle(
                              color: isDark ? Colors.white38 : Colors.black38,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Consumer<AuthProvider>(
                            builder: (context, auth, child) {
                              return Text(
                                auth.currentUser?.displayName ?? 'User',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildHeaderIcon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, isDark, onTap: () {
                      themeProvider.toggleTheme();
                    }),
                    const SizedBox(width: 12),
                    _buildHeaderIcon(Icons.person_outline_rounded, isDark, onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Profilepage()),
                      );
                    }),
                  ],
                ),
              ),

              // 2. Hero Balance Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161B22) : Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                    ],
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Active Balance',
                            style: TextStyle(
                              color: isDark ? Colors.white38 : Colors.black38,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blueAccent),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Consumer<PortfolioProvider>(
                        builder: (context, provider, _) {
                          final balanceStr = provider.balance.toStringAsFixed(2);
                          final parts = balanceStr.split('.');
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '\$${parts[0]}',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                ),
                              ),
                              Text(
                                '.${parts[1]}',
                                style: TextStyle(
                                  color: (isDark ? Colors.white : Colors.black).withOpacity(0.5),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildMiniIndicator('+ \$12,432', '+ 8.2%', true),
                          const SizedBox(width: 12),
                          _buildMiniIndicator('- \$1,213', '- 1.5%', false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 3. Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionItem('Deposit', Icons.add_rounded, Colors.blueAccent, isDark),
                    _buildActionItem('Trade', Icons.swap_horiz_rounded, Colors.orangeAccent, isDark),
                    _buildActionItem('History', Icons.history_rounded, Colors.greenAccent, isDark),
                    _buildActionItem('More', Icons.grid_view_rounded, Colors.purpleAccent, isDark),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 4. Explore Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Explore Market',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'See All',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Consumer<StockProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final stocks = provider.mostActive.take(8).toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stocks.length,
                    itemBuilder: (context, index) {
                      final stock = stocks[index];
                      return _buildMarketItem(stock, isDark);
                    },
                  );
                },
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, bool isDark, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Icon(icon, size: 22, color: isDark ? Colors.white70 : Colors.black54),
      ),
    );
  }

  Widget _buildMiniIndicator(String value, String percent, bool isPositive) {
    final color = isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Text(
            ' ($percent)',
            style: TextStyle(color: color.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(String label, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161B22) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildMarketItem(dynamic stock, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22).withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.03),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StockDetailScreen(
                symbol: stock['symbol'],
                name: stock['name'],
                price: stock['price'],
                change: stock['changesPercentage'],
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stock['symbol'][0],
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock['symbol'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    stock['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              height: 30,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 1),
                        const FlSpot(1, 1.5),
                        const FlSpot(2, 1.2),
                        const FlSpot(3, 2),
                        const FlSpot(4, 1.8),
                      ],
                      isCurved: true,
                      color: stock['changesPercentage'] >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${stock['price'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '${stock['changesPercentage'] >= 0 ? '+' : ''}${stock['changesPercentage'].toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: stock['changesPercentage'] >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeaderAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Profilepage()),
        );
      },
      child: const CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
      ),
    );
  }

}