import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_hub/Model/movie_model.dart';

class MovieApiService {
  static const String _baseUrl = 'https://imdb232.p.rapidapi.com/api/v1/search';

  static const String _apiKey = "656a642c8fmsh6e402295f1422b3p11989cjsn10cca2e76192";
  static const String _apiHost = 'imdb232.p.rapidapi.com';

  Future<List<Entity>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];

    final Uri url = Uri.parse('$_baseUrl?query=${Uri.encodeComponent(query)}');

    final Map<String, String> headers = {
      'x-rapidapi-key': _apiKey,
      'x-rapidapi-host': _apiHost,
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final movieModel = MovieModel.fromJson(jsonMap);

        final edges = movieModel.data?.mainSearch?.edges ?? [];
        return edges
            .map((edge) => edge.node?.entity)
            .whereType<Entity>()
            .toList();
      } else {
        throw Exception(
            'Failed to load movies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('MovieApiService Error: $e');
      rethrow;
    }
  }
}