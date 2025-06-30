import 'package:flutter/material.dart';

class Viewmorepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.appBarTheme.iconTheme,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NVIDIA (NVDA) Shares Surge 6% After AI Chip Reveal',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: April 24, 2025',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? const Color(0xFF606060) : Colors.grey[700],
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "NVIDIA's stock (NVDA) jumped 6% today following the announcement of its cutting-edge 'Blackwell' AI processors during the company's annual developer event.",
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Key Highlights:\n',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: '\n', style: theme.textTheme.bodyLarge),
                    TextSpan(
                      text: 'The Blackwell chips are designed to accelerate AI workloads across cloud and enterprise platforms.\n',
                      style: theme.textTheme.bodyLarge?.copyWith(color: isDark ? const Color(0xFF979797) : Colors.grey[800], fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: '\n', style: theme.textTheme.bodyLarge),
                    TextSpan(
                      text: 'Pre-orders have exceeded \$2 billion, signalling massive interest from tech giants and cloud providers.\n',
                      style: theme.textTheme.bodyLarge?.copyWith(color: isDark ? const Color(0xFF979797) : Colors.grey[800], fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: '\n', style: theme.textTheme.bodyLarge),
                    TextSpan(
                      text: 'The announcement reinforces NVIDIA leadership in the AI hardware space.',
                      style: theme.textTheme.bodyLarge?.copyWith(color: isDark ? const Color(0xFF979797) : Colors.grey[800], fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Competitor Impact:',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'AMD (AMD) shares dipped 2.1%\n',
                      style: theme.textTheme.bodyLarge?.copyWith(color: isDark ? const Color(0xFF767676) : Colors.grey[700], fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: '\n', style: theme.textTheme.bodyLarge),
                    TextSpan(
                      text: "Intel (INTC) shares fell 1.8% Analysts attribute this dip to market anticipation of NVIDIA's growing dominance in the AI race.",
                      style: theme.textTheme.bodyLarge?.copyWith(color: isDark ? const Color(0xFF767676) : Colors.grey[700], fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Quote:',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                '"NVIDIA has just raised the bar for everyone in AI infrastructure."',
                style: theme.textTheme.bodyLarge?.copyWith(color: isDark ? const Color(0xFF979797) : Colors.grey[800], fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}