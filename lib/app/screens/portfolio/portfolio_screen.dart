import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portfolio_provider.dart';
import '../../widgets/portfolio_summary.dart';
import '../../widgets/stock_list.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDark 
            ? const Color(0xFF0F1419)
            : const Color(0xFFF8FAFC),
        ),
        child: Column(
          children: [
            // Header Section with Gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark 
                    ? [
                        const Color(0xFF1A1A2E),
                        const Color(0xFF16213E),
                      ]
                    : [
                        const Color(0xFF667EEA),
                        const Color(0xFF764BA2),
                      ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Portfolio',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Investment Overview',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Consumer<PortfolioProvider>(
                        builder: (context, provider, _) {
                          return Text(
                            'Balance: \$${provider.balance.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Content Section
            Expanded(
              child: Container(
                color: isDark 
                  ? const Color(0xFF0F1419)
                  : const Color(0xFFF8FAFC),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Portfolio Summary Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark 
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isDark 
                                ? Colors.black.withOpacity(0.3) 
                                : Colors.grey.withOpacity(0.08),
                              blurRadius: isDark ? 20 : 10,
                              offset: Offset(0, isDark ? 8 : 4),
                            ),
                          ],
                          border: isDark 
                            ? Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              )
                            : Border.all(
                                color: Colors.grey.withOpacity(0.1),
                                width: 1,
                              ),
                        ),
                        child: Consumer<PortfolioProvider>(
                          builder: (context, provider, child) {
                            return PortfolioSummary(
                              totalValue: provider.balance,
                              percentageGain: 0, // Or calculate based on initial balance if you want
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Holdings Section Header
                      Row(
                        children: [
                          Text(
                            'Your Holdings',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDark 
                                ? Colors.white.withOpacity(0.1)
                                : const Color(0xFF667EEA).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark 
                                  ? Colors.white.withOpacity(0.2)
                                  : const Color(0xFF667EEA).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Consumer<PortfolioProvider>(
                              builder: (context, provider, _) {
                                return Text(
                                  '${provider.stocks.length} Stocks',
                                  style: TextStyle(
                                    color: isDark 
                                      ? Colors.white.withOpacity(0.8)
                                      : const Color(0xFF667EEA),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Stock List Container
                      Container(
                        decoration: BoxDecoration(
                          color: isDark 
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: isDark 
                                ? Colors.black.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.08),
                              blurRadius: isDark ? 15 : 10,
                              offset: Offset(0, isDark ? 5 : 4),
                            ),
                          ],
                          border: isDark 
                            ? Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              )
                            : Border.all(
                                color: Colors.grey.withOpacity(0.1),
                                width: 1,
                              ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            constraints: const BoxConstraints(
                              minHeight: 400,
                              maxHeight: 600,
                            ),
                            child: const StockList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}