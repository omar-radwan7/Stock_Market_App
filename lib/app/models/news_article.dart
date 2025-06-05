class NewsArticle {
  final String title;
  final String description;
  final String imageUrl;
  final String time;
  final String source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.time,
    required this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      time: json['time'] as String,
      source: json['source'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'time': time,
      'source': source,
    };
  }
} 