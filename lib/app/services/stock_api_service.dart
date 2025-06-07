import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class StockApiService {
  final String _apiKey = 'PnYR369Zox71sMMwscIKClom3f1a9jTn';
  final String _baseUrl = 'https://financialmodelingprep.com/api/v3';

  Future<bool> testConnection() async {
    try {
      print('Testing API connection...'); // Debug log
      final response = await http
          .get(Uri.parse('$_baseUrl/stock/list?apikey=$_apiKey'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timed out'),
          );

      print('Test connection status code: ${response.statusCode}'); // Debug log
      print(
        'Test connection response: ${response.body.substring(0, min(100, response.body.length))}...',
      ); // Debug log

      return response.statusCode == 200;
    } catch (e) {
      print('Test connection error: $e'); // Debug log
      return false;
    }
  }

  Future<List<dynamic>> fetchTopGainers() async {
    try {
      final url = '$_baseUrl/stock_market/gainers?apikey=$_apiKey';
      print('Fetching top gainers from: $url'); // Debug URL

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timed out'),
          );

      print(
        'Top gainers response status: ${response.statusCode}',
      ); // Debug status code
      print('Top gainers response body: ${response.body}'); // Debug response

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          print(
            'Successfully parsed ${data.length} top gainers',
          ); // Debug data length
          return data;
        } else {
          throw Exception(
            'Invalid response format: expected List but got ${data.runtimeType}',
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key - please check your API key configuration',
        );
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded - please try again later');
      } else {
        throw Exception(
          'Failed to load top gainers: ${response.statusCode}\nResponse: ${response.body}',
        );
      }
    } catch (e) {
      print('Error in fetchTopGainers: $e'); // Debug log
      rethrow;
    }
  }

  Future<List<dynamic>> fetchTopLosers() async {
    try {
      final url = '$_baseUrl/stock_market/losers?apikey=$_apiKey';
      print('Fetching top losers from: $url'); // Debug URL

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timed out'),
          );

      print(
        'Top losers response status: ${response.statusCode}',
      ); // Debug status code
      print('Top losers response body: ${response.body}'); // Debug response

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          print(
            'Successfully parsed ${data.length} top losers',
          ); // Debug data length
          return data;
        } else {
          throw Exception(
            'Invalid response format: expected List but got ${data.runtimeType}',
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key - please check your API key configuration',
        );
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded - please try again later');
      } else {
        throw Exception(
          'Failed to load top losers: ${response.statusCode}\nResponse: ${response.body}',
        );
      }
    } catch (e) {
      print('Error in fetchTopLosers: $e'); // Debug log
      rethrow;
    }
  }

  Future<List<dynamic>> fetchMostActive() async {
    try {
      final url = '$_baseUrl/stock_market/actives?apikey=$_apiKey';
      print('Fetching most active from: $url'); // Debug URL

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timed out'),
          );

      print(
        'Most active response status: ${response.statusCode}',
      ); // Debug status code
      print('Most active response body: ${response.body}'); // Debug response

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          print(
            'Successfully parsed ${data.length} most active stocks',
          ); // Debug data length
          return data;
        } else {
          throw Exception(
            'Invalid response format: expected List but got ${data.runtimeType}',
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key - please check your API key configuration',
        );
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded - please try again later');
      } else {
        throw Exception(
          'Failed to load most active stocks: ${response.statusCode}\nResponse: ${response.body}',
        );
      }
    } catch (e) {
      print('Error in fetchMostActive: $e'); // Debug log
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
            const Duration(seconds: 10),
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
}
