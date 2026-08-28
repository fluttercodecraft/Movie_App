import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_hub/Model/movie_model.dart';

class MovieApiService {
  final String baseUrl = 'YOUR_API_URL';
  final String apiKey = 'YOUR_API_KEY';

  Future<List<MovieModel>> getMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List movies = data['results'];


        return
           MovieModel.map((movie) => MovieModel.fromJson(movie))
            .toList();
      } else {
        throw Exception(
          'Failed to load movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }
}