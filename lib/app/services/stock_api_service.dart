import 'dart:convert';
import 'package:http/http.dart' as http;

class StockApiService {
  final String _apiKey = 'Your API Here Please:)';
  final String _baseUrl = 'https://financialmodelingprep.com/api/v3';

  Future<bool> testConnection() async {
    try {
      print('Testing API connection...'); // Debug log
      final response = await http
          .get(Uri.parse('$_baseUrl/stock/list?apikey=$_apiKey'))
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Request timed out'),
          );

      print('Test connection status code: ${response.statusCode}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API connection successful. Response: ${json.encode(data)}');
        return true;
      } else {
        print(
          'API connection failed. Status: ${response.statusCode}, Body: ${response.body}',
        );
        return false;
      }
    } catch (e, stackTrace) {
      print('Test connection error: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<List<dynamic>> fetchTopGainers() async {
    try {
      final url = '$_baseUrl/stock_market/gainers?apikey=$_apiKey';
      print('Fetching top gainers from: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Request timed out'),
          );

      print('Top gainers response status: ${response.statusCode}');
      print('Top gainers response headers: ${response.headers}');
      print('Top gainers response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          print('Successfully parsed ${data.length} top gainers');
          return data;
        } else {
          throw Exception(
            'Invalid response format: expected List but got ${data.runtimeType}',
          );
        }
      } else {
        throw Exception(
          'Failed to load top gainers. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e, stackTrace) {
      print('Error in fetchTopGainers: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchTopLosers() async {
    try {
      final url = '$_baseUrl/stock_market/losers?apikey=$_apiKey';
      print('Fetching top losers from: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Request timed out'),
          );

      print('Top losers response status: ${response.statusCode}');
      print('Top losers response headers: ${response.headers}');
      print('Top losers response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          print('Successfully parsed ${data.length} top losers');
          return data;
        } else {
          throw Exception(
            'Invalid response format: expected List but got ${data.runtimeType}',
          );
        }
      } else {
        throw Exception(
          'Failed to load top losers. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e, stackTrace) {
      print('Error in fetchTopLosers: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchMostActive() async {
    try {
      final url = '$_baseUrl/stock_market/actives?apikey=$_apiKey';
      print('Fetching most active from: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Request timed out'),
          );

      print('Most active response status: ${response.statusCode}');
      print('Most active response headers: ${response.headers}');
      print('Most active response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          print('Successfully parsed ${data.length} most active stocks');
          return data;
        } else {
          throw Exception(
            'Invalid response format: expected List but got ${data.runtimeType}',
          );
        }
      } else {
        throw Exception(
          'Failed to load most active stocks. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e, stackTrace) {
      print('Error in fetchMostActive: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchStockQuote(String symbol) async {
    try {
      final url = '$_baseUrl/quote/$symbol?apikey=$_apiKey';
      print('Fetching quote for $symbol from: $url'); // Debug URL

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Request timed out'),
          );

      print(
        'Quote response status: ${response.statusCode}',
      ); // Debug status code
      print('Quote response body: ${response.body}'); // Debug response

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          print('Successfully parsed quote data for $symbol'); // Debug success
          return data.first;
        } else {
          throw Exception('No quote data found for symbol: $symbol');
        }
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key - please check your API key configuration',
        );
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded - please try again later');
      } else {
        throw Exception(
          'Failed to load stock quote: ${response.statusCode}\nResponse: ${response.body}',
        );
      }
    } catch (e) {
      print('Error in fetchStockQuote: $e'); // Debug log
      rethrow;
    }
  }

  Future<List<dynamic>> fetchMarketNews() async {
    try {
      final url = '$_baseUrl/fmp/articles?page=0&size=50&apikey=$_apiKey';
      print('Fetching market news from: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw Exception('Request timed out'),
          );

      print('Market news response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          print('Successfully parsed ${data.length} news articles');
          return data;
        } else {
          throw Exception('Invalid response format for news');
        }
      } else {
        throw Exception(
          'Failed to load market news. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e, stackTrace) {
      print('Error in fetchMarketNews: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
