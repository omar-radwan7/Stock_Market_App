import 'package:flutter/material.dart';

class PortfolioSummary extends StatelessWidget {
  final double totalValue;
  final double percentageGain;

  const PortfolioSummary({
    super.key,
    required this.totalValue,
    required this.percentageGain,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LIVE PORTFOLIO',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.more_horiz,
                color: isDark ? Colors.white38 : Colors.black26,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '\$${totalValue.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 42,
              fontWeight: FontWeight.w400, // Thinner, more elegant weight
              fontFamily: 'Courier', // Or any monospace font for a vault feel
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                percentageGain >= 0 ? '收益 (Profit)' : '亏损 (Loss)',
                style: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${percentageGain >= 0 ? '+' : ''}${percentageGain.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: percentageGain >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                percentageGain >= 0 ? Icons.north_east : Icons.south_east,
                size: 14,
                color: percentageGain >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Divider(color: isDark ? Colors.white10 : Colors.black12),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('WEEKLY', '+2.4%', true, isDark),
              _buildMetric('MONTHLY', '+8.1%', true, isDark),
              _buildMetric('ANNUAL', '+24.5%', true, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, bool isPositive, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
