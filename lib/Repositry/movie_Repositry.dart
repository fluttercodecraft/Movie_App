import 'package:movie_hub/Models/MovieModel.dart';
import 'package:movie_hub/Services/movie_api_services.dart';

/// Thrown when the repository can't return movies.
class MovieRepositoryException implements Exception {
  final String message;
  final Object? cause;

  const MovieRepositoryException(this.message, {this.cause});

  @override
  String toString() => 'MovieRepositoryException: $message';
}

class MovieRepository {
  MovieRepository({MovieApiService? apiService})
      : _apiService = apiService ?? MovieApiService();

  final MovieApiService _apiService;

  Future<List<Items>> searchMovies({
    required String query,
    int page = 1,
    String? name,
  }) {
    final effectiveQuery = query.isNotEmpty ? query : (name ?? '');
    return _guard(
      'Unable to search movies',
      () => _apiService.searchMovies(query: effectiveQuery, page: page),
    );
  }

  Future<List<Items>> getTrending({int page = 1}) {
    return _guard(
      'Unable to load trending movies',
      () => _apiService.getTrending(page: page),
    );
  }

  Future<List<Items>> getPopular({int page = 1}) {
    return _guard(
      'Unable to load popular movies',
      () => _apiService.getPopular(page: page),
    );
  }

  Future<List<Items>> getNowPlaying({int page = 1}) {
    return _guard(
      'Unable to load now-playing movies',
      () => _apiService.getNowPlaying(page: page),
    );
  }

  Future<List<Items>> getTopRated({int page = 1}) {
    return _guard(
      'Unable to load top-rated movies',
      () => _apiService.getTopRated(page: page),
    );
  }

  /// Loads all home-screen sections in parallel for high performance.
  Future<HomeMovies> getHomeMovies() async {
    final results = await Future.wait([
      getTrending(),
      getPopular(),
      getNowPlaying(),
      getTopRated(),
    ]);

    final trending = results[0];
    final popular = results[1];
    final nowPlaying = results[2];
    final topRated = results[3];

    final featured = trending.isNotEmpty
        ? trending.take(5).toList()
        : popular.take(5).toList();

    return HomeMovies(
      featured: featured,
      trending: trending,
      popular: popular,
      nowPlaying: nowPlaying,
      topRated: topRated,
    );
  }

  Future<T> _guard<T>(String message, Future<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      throw MovieRepositoryException(message, cause: e);
    }
  }

  void dispose() => _apiService.dispose();
}

/// Bundles the movie lists the home screen needs.
class HomeMovies {
  final List<Items> featured;
  final List<Items> trending;
  final List<Items> popular;
  final List<Items> nowPlaying;
  final List<Items> topRated;

  const HomeMovies({
    required this.featured,
    required this.trending,
    required this.popular,
    required this.nowPlaying,
    required this.topRated,
  });
}