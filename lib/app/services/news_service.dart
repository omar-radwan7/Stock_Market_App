class NewsArticle {
  final String title;
  final String description;
  final String timeAgo;
  final String imageUrl;
  final String source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.imageUrl,
    required this.source,
  });
}

class NewsService {
  Future<List<NewsArticle>> fetchNews() async {
    try {
      // For now, return mock data since we don't have a real API
      return [
        NewsArticle(
          title: 'Bitcoin Surges Past \$50,000',
          description: 'Bitcoin has reached a new all-time high, surpassing \$50,000 for the first time in 2024.',
          timeAgo: '2 hours ago',
          imageUrl: 'https://placehold.co/400x200',
          source: 'Crypto News',
        ),
        NewsArticle(
          title: 'Ethereum 2.0 Upgrade Complete',
          description: 'The long-awaited Ethereum 2.0 upgrade has been successfully completed, bringing improved scalability and security.',
          timeAgo: '5 hours ago',
          imageUrl: 'https://placehold.co/400x200',
          source: 'Blockchain Daily',
        ),
        NewsArticle(
          title: 'New Cryptocurrency Regulations',
          description: 'Global financial regulators announce new framework for cryptocurrency trading and investment.',
          timeAgo: '1 day ago',
          imageUrl: 'https://placehold.co/400x200',
          source: 'Financial Times',
        ),
      ];
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }
} 