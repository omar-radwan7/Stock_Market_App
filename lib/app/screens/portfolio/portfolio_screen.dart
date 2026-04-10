import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_app/app/screens/profile/profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/portfolio_provider.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back',
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
                    _buildIconCircle(Icons.notifications_none_rounded, isDark),
                  ],
                ),
              ),

              // 2. Portfolio Value Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio Value',
                      style: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black38,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Consumer<PortfolioProvider>(
                      builder: (context, provider, _) {
                        final balanceStr = provider.balance.toStringAsFixed(2);
                        final parts = balanceStr.split('.');
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isVisible ? '\$${parts[0]}.${parts[1]}' : '••••••••',
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Your profit is \$411,234.72',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _isVisible = !_isVisible),
                                  child: Icon(
                                    _isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    color: isDark ? Colors.white38 : Colors.black26,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.arrow_upward, color: Color(0xFF10B981), size: 14),
                                      Text(
                                        ' 8.2%',
                                        style: TextStyle(
                                          color: Color(0xFF10B981),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Your Portfolio Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Portfolio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'Add New',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white54 : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildPortfolioCategoryCard('Saving', '\$4,342.71', '+ 8.2%', Icons.account_balance_wallet_outlined, isDark),
                    _buildPortfolioCategoryCard('Daily', '\$3,187.90', '+ 4.5%', Icons.calendar_today_outlined, isDark),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 4. Promo Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Introduce Vestgrow',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'For you who want to explore more',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Learn More',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 5. Recommendation Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommendation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'See More',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white54 : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildRecommendationItem('ADS', 'Adidas AG (ADS)', '\$200.49', '+ 0.76%', isDark),
                    _buildRecommendationItem('AAPL', 'Apple Inc. (AAPL)', '\$189.43', '+ 0.45%', isDark),
                  ],
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconCircle(IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Icon(icon, size: 22, color: isDark ? Colors.white70 : Colors.black54),
    );
  }

  Widget _buildPortfolioCategoryCard(String title, String value, String percent, IconData icon, bool isDark) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(24),
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
              Icon(icon, color: isDark ? Colors.white38 : Colors.black38, size: 20),
              const Icon(Icons.more_horiz, color: Colors.black26, size: 20),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your profit this goal $percent',
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF10B981),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String ticker, String name, String price, String change, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                ticker.substring(0, 1),
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
                  ticker,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.arrow_upward, color: Color(0xFF10B981), size: 10),
                  Text(
                    ' $change',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
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
