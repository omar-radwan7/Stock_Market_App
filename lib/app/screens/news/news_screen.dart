import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/news_provider.dart';

class NewsPage extends StatelessWidget {
  final List<Map<String, dynamic>> curatedNews = [
    {
      'title': 'Fed Rate Decision: Market Impact Analysis for March 2024',
      'summary':
          'Federal Reserve expected to begin rate cuts in Q2 2024, potentially starting in June. Markets show increased volatility in anticipation.',
      'fullContent': '''
The Federal Reserve's upcoming decisions in 2024 are poised to significantly impact market dynamics. With inflation showing consistent signs of cooling, analysts are focusing on the timing of potential rate cuts.

Key Expectations:
• First rate cut likely in June 2024
• Total of 3-4 cuts expected throughout 2024
• Target rate projected to reach 4.5% by year-end

Market Implications:
- Tech stocks expected to benefit from lower rates
- Banking sector preparing for margin adjustments
- Real estate market anticipating increased activity

Expert Analysis:
"The Fed's transition from fighting inflation to supporting growth will be this year's key market driver," notes Sarah Chen, Chief Market Strategist at Global Markets Research. "Early indicators suggest a careful approach to rate reductions, with particular attention to employment data and core inflation metrics."

Investment Opportunities:
• Growth stocks likely to outperform
• Bond market repositioning expected
• Real estate sector showing early momentum
      ''',
      'date': 'March 15, 2024',
      'source': 'Market Strategy Weekly',
      'category': 'Monetary Policy',
    },
    {
      'title': 'AI Sector Outlook: Q2 2024 Growth Projections',
      'summary':
          'Major tech companies set to release new AI products in Q2, with significant implications for semiconductor and cloud computing stocks.',
      'fullContent': '''
The artificial intelligence sector is preparing for a transformative second quarter, with multiple major product launches and technological breakthroughs expected.

Upcoming Catalysts:
• New AI chip releases from leading manufacturers
• Enterprise AI platform expansions
• Major cloud providers upgrading AI infrastructure

Market Impact Predictions:
- Semiconductor stocks expected to see increased demand
- Cloud computing providers likely to benefit
- AI-focused startups attracting significant investment

Key Companies to Watch:
- NVIDIA: New AI chip architecture launch
- AMD: Enhanced AI processing capabilities
- Microsoft: Azure AI platform expansion
- Google: Advanced language model deployment

Industry Expert View:
"Q2 2024 represents a critical phase in AI commercialization," explains Dr. James Wong, AI Industry Analyst. "We're seeing a shift from research to practical applications, which could drive significant market opportunities."

Investment Considerations:
• Semiconductor sector momentum
• Cloud computing infrastructure plays
• AI software and services expansion
      ''',
      'date': 'March 18, 2024',
      'source': 'Tech Market Insights',
      'category': 'Technology',
    },
    {
      'title': 'Global Supply Chain Shift: Asian Markets in Focus',
      'summary':
          'Major manufacturing relocations and trade agreements expected to reshape Asian markets in Q2 2024, creating new investment opportunities.',
      'fullContent': '''
Asian markets are poised for significant transformation as global companies accelerate manufacturing diversification and new trade agreements take effect.

Emerging Trends:
• Manufacturing shift to Southeast Asia
• New regional trade partnerships
• Technology sector expansion in South Korea and Taiwan

Market Opportunities:
- Vietnamese manufacturing stocks
- Indian technology sector
- Singapore financial services
- Indonesian consumer markets

Economic Impact:
"The redistribution of manufacturing capacity across Asia creates unique investment opportunities," states Michelle Lee, Asian Markets Analyst at Eastern Capital. "Countries with strong infrastructure and favorable policies are likely to see increased foreign investment and economic growth."

Key Developments to Watch:
• New trade agreement implementations
• Infrastructure project announcements
• Foreign investment policy changes
• Technology sector expansions

Investment Sectors:
- Manufacturing and logistics
- Technology and semiconductors
- Financial services
- Consumer markets
      ''',
      'date': 'March 20, 2024',
      'source': 'Asian Markets Review',
      'category': 'Global Markets',
    },
    {
      'title': 'Energy Market Transformation: Q2 2024 Outlook',
      'summary':
          'Renewable energy sector expected to see major policy support and investment growth, while traditional energy adapts to changing market dynamics.',
      'fullContent': '''
The energy sector is approaching a critical transition period in Q2 2024, with both renewable and traditional energy markets facing significant changes.

Key Trends:
• Renewable energy policy initiatives
• Traditional energy adaptation strategies
• Energy storage technology advancement
• Grid infrastructure modernization

Market Projections:
- Solar sector growth acceleration
- Wind energy project expansions
- Battery technology investments
- Traditional energy transformation

Expert Insight:
"The energy sector is at an inflection point," notes Dr. Sarah Martinez, Energy Sector Analyst. "Policy support for renewables, combined with technological advances, is creating compelling investment opportunities while traditional energy companies are strategically repositioning."

Investment Opportunities:
• Solar technology companies
• Grid infrastructure providers
• Energy storage solutions
• Traditional energy transition plays

Regulatory Impact:
- New clean energy incentives
- Grid modernization funding
- Carbon pricing initiatives
- Energy efficiency standards
      ''',
      'date': 'March 21, 2024',
      'source': 'Energy Market Report',
      'category': 'Energy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 70,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Market News',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      // Profile Button
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isDark 
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(18),
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
                            size: 18,
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
                      // Header Section
                      Text(
                        'Latest Market Updates',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stay informed with the latest financial news and market insights',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark 
                            ? Colors.white.withOpacity(0.7)
                            : const Color.fromARGB(0, 10, 10, 10),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // News Cards
                      ...curatedNews.map((article) => NewsCard(
                        title: article['title']!,
                        summary: article['summary']!,
                        fullContent: article['fullContent']!,
                        date: article['date']!,
                        source: article['source']!,
                        category: article['category']!,
                        isDark: isDark,
                      )).toList(),
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
}

class NewsCard extends StatefulWidget {
  final String title;
  final String summary;
  final String fullContent;
  final String date;
  final String source;
  final String category;
  final bool isDark;

  const NewsCard({
    Key? key,
    required this.title,
    required this.summary,
    required this.fullContent,
    required this.date,
    required this.source,
    required this.category,
    required this.isDark,
  }) : super(key: key);

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getCategoryColor() {
    switch (widget.category) {
      case 'Technology':
        return Colors.purple;
      case 'Monetary Policy':
        return Colors.blue;
      case 'Global Markets':
        return Colors.orange;
      case 'Energy':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: widget.isDark 
          ? const Color(0xFF2D3748)
          : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.isDark 
              ? Colors.black.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: widget.isDark 
          ? Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            )
          : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
              if (_isExpanded) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: categoryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.category,
                        style: TextStyle(
                          color: categoryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isDark 
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.date,
                        style: TextStyle(
                          color: widget.isDark 
                            ? Colors.white.withOpacity(0.6)
                            : Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isDark ? Colors.white : Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Content
                AnimatedCrossFade(
                  firstChild: Text(
                    widget.summary,
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.isDark 
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  secondChild: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      widget.fullContent,
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.isDark 
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                  crossFadeState: _isExpanded 
                    ? CrossFadeState.showSecond 
                    : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
                const SizedBox(height: 16),
                
                // Footer Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isDark 
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: categoryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.source,
                            style: TextStyle(
                              color: widget.isDark 
                                ? Colors.white.withOpacity(0.6)
                                : Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: widget.isDark 
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _isExpanded ? 'Show Less' : 'Read More',
                        style: TextStyle(
                          color: categoryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}