import 'package:flutter/material.dart';

class Premiumpage extends StatelessWidget {
  const Premiumpage({super.key});

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
                      // Header with back button
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '←',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Premium Plans',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 32), // Balance the layout
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Title and Subtitle
                      Text(
                        'Choose Your Plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Unlock advanced features and insights to maximize your trading potential',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
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
                    children: [
                      _buildPricingPlan(
                        context,
                        'Basic',
                        19,
                        'Perfect for beginners',
                        isDark,
                        false,
                        [
                          'Basic stock analysis',
                          'Limited watchlists',
                          'Standard market reports',
                          'Email support',
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      _buildPricingPlan(
                        context,
                        'Pro',
                        39,
                        'Most popular choice',
                        isDark,
                        true, // Popular plan
                        [
                          'Advanced stock analysis',
                          'Unlimited watchlists',
                          'Premium market reports',
                          'Priority support',
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      _buildPricingPlan(
                        context,
                        'Business',
                        79,
                        'For growing teams',
                        isDark,
                        false,
                        [
                          'Professional trading tools',
                          'Team collaboration',
                          'Custom reports',
                          '24/7 dedicated support',
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      _buildPricingPlan(
                        context,
                        'Enterprise',
                        149,
                        'Complete solution',
                        isDark,
                        false,
                        [
                          'Full API access',
                          'Custom solutions',
                          'Dedicated account manager',
                          'On-site training',
                        ],
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

  Widget _buildPricingPlan(
    BuildContext context,
    String title,
    int price,
    String subtitle,
    bool isDark,
    bool isPopular,
    List<String> features,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark 
          ? const Color(0xFF1E293B)
          : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? Colors.black.withOpacity(0.2)
              : Colors.grey.withOpacity(0.08),
            blurRadius: isDark ? 15 : 10,
            offset: Offset(0, isDark ? 5 : 4),
          ),
        ],
        border: isPopular
          ? Border.all(
              color: const Color(0xFF667EEA),
              width: 2,
            )
          : isDark 
            ? Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              )
            : Border.all(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: isDark 
                                ? Colors.white.withOpacity(0.6)
                                : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$$price',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '/month',
                        style: TextStyle(
                          color: isDark 
                            ? Colors.white.withOpacity(0.7)
                            : Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Features Header
                Text(
                  'What\'s included',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Features List
                ...features.map((feature) => _buildFeatureItem(feature, isDark)),
                const SizedBox(height: 24),
                
                // Choose Plan Button
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isPopular
                      ? const LinearGradient(
                          colors: [
                            Color(0xFF667EEA),
                            Color(0xFF764BA2),
                          ],
                        )
                      : null,
                    color: isPopular 
                      ? null 
                      : (isDark 
                          ? Colors.white.withOpacity(0.1)
                          : const Color(0xFF667EEA).withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(12),
                    border: !isPopular
                      ? Border.all(
                          color: isDark 
                            ? Colors.white.withOpacity(0.2)
                            : const Color(0xFF667EEA).withOpacity(0.3),
                          width: 1,
                        )
                      : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // TODO: Handle plan selection
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected $title plan'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          isPopular ? 'Get Started' : 'Choose Plan',
                          style: TextStyle(
                            color: isPopular 
                              ? Colors.white
                              : (isDark 
                                  ? Colors.white.withOpacity(0.9)
                                  : const Color(0xFF667EEA)),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Popular Badge
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF667EEA),
                      Color(0xFF764BA2),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '✓',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark 
                  ? Colors.white.withOpacity(0.8)
                  : Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}