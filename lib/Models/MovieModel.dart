/// Movie Data Models supporting TMDB, Open API, and offline datasets.
class MovieModel {
  MovieModel({
    List<Items>? items,
    Meta? meta,
  }) {
    _items = items;
    _meta = meta;
  }

  MovieModel.fromJson(dynamic json) {
    if (json == null) return;
    if (json is List) {
      _items = json.map((v) => Items.fromJson(v)).toList();
      _meta = Meta(
        count: _items?.length ?? 0,
        currentPage: 1,
        itemsPerPage: _items?.length ?? 0,
        numberOfPages: 1,
      );
      return;
    }

    if (json is Map<String, dynamic>) {
      // Support TMDB format (results)
      if (json['results'] != null && json['results'] is List) {
        _items = (json['results'] as List)
            .map((v) => Items.fromJson(v))
            .toList();
        _meta = Meta(
          count: json['total_results'] ?? _items?.length ?? 0,
          currentPage: json['page'] ?? 1,
          itemsPerPage: _items?.length ?? 0,
          numberOfPages: json['total_pages'] ?? 1,
        );
      } else if (json['items'] != null && json['items'] is List) {
        // Support custom items format
        _items = (json['items'] as List)
            .map((v) => Items.fromJson(v))
            .toList();
        _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
      }
    }
  }

  List<Items>? _items;
  Meta? _meta;

  MovieModel copyWith({
    List<Items>? items,
    Meta? meta,
  }) =>
      MovieModel(
        items: items ?? _items,
        meta: meta ?? _meta,
      );

  List<Items>? get items => _items;
  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    return map;
  }
}

class Meta {
  Meta({
    num? count,
    num? currentPage,
    num? itemsPerPage,
    num? numberOfPages,
  }) {
    _count = count;
    _currentPage = currentPage;
    _itemsPerPage = itemsPerPage;
    _numberOfPages = numberOfPages;
  }

  Meta.fromJson(dynamic json) {
    if (json == null) return;
    _count = json['count'] ?? json['total_results'];
    _currentPage = json['current_page'] ?? json['page'];
    _itemsPerPage = json['items_per_page'];
    _numberOfPages = json['number_of_pages'] ?? json['total_pages'];
  }

  num? _count;
  num? _currentPage;
  num? _itemsPerPage;
  num? _numberOfPages;

  Meta copyWith({
    num? count,
    num? currentPage,
    num? itemsPerPage,
    num? numberOfPages,
  }) =>
      Meta(
        count: count ?? _count,
        currentPage: currentPage ?? _currentPage,
        itemsPerPage: itemsPerPage ?? _itemsPerPage,
        numberOfPages: numberOfPages ?? _numberOfPages,
      );

  num? get count => _count;
  num? get currentPage => _currentPage;
  num? get itemsPerPage => _itemsPerPage;
  num? get numberOfPages => _numberOfPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['current_page'] = _currentPage;
    map['items_per_page'] = _itemsPerPage;
    map['number_of_pages'] = _numberOfPages;
    return map;
  }
}

class Items {
  Items({
    dynamic id,
    String? title,
    String? name,
    String? releaseDate,
    String? originalLanguage,
    num? popularity,
    String? overview,
    num? voteAverage,
    num? voteCount,
    String? posterPath,
    String? backdropPath,
    List<int>? genreIds,
    List<String>? genres,
  }) {
    _id = id;
    _title = title ?? name;
    _releaseDate = releaseDate;
    _originalLanguage = originalLanguage;
    _popularity = popularity;
    _overview = overview;
    _voteAverage = voteAverage;
    _voteCount = voteCount;
    _posterPath = posterPath;
    _backdropPath = backdropPath;
    _genreIds = genreIds;
    _genres = genres;
  }

  Items.fromJson(dynamic json) {
    if (json == null) return;
    if (json is Map<String, dynamic>) {
      _id = json['id'];
      _title = json['title'] ?? json['name'] ?? json['original_title'];
      _releaseDate = json['release_date'] ?? json['first_air_date'] ?? json['premiered'];
      _originalLanguage = json['original_language'] ?? json['language'];
      _popularity = json['popularity'] is num ? json['popularity'] : (num.tryParse('${json['popularity']}') ?? 0);
      
      // Overview parsing (clean HTML tags if from TVmaze)
      String? rawOverview = json['overview'] ?? json['summary'];
      if (rawOverview != null) {
        _overview = rawOverview.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();
      }
      
      _voteAverage = json['vote_average'] is num
          ? json['vote_average']
          : (json['rating'] is Map && json['rating']['average'] is num
              ? json['rating']['average']
              : (num.tryParse('${json['vote_average']}') ?? 0));
              
      _voteCount = json['vote_count'] is num
          ? json['vote_count']
          : (num.tryParse('${json['vote_count']}') ?? 0);
          
      _posterPath = json['poster_path'] ??
          (json['image'] is Map ? json['image']['medium'] ?? json['image']['original'] : null) ??
          json['poster'];
          
      _backdropPath = json['backdrop_path'] ??
          (json['image'] is Map ? json['image']['original'] ?? json['image']['medium'] : null) ??
          json['backdrop'];

      if (json['genre_ids'] != null && json['genre_ids'] is List) {
        _genreIds = (json['genre_ids'] as List)
            .whereType<num>()
            .map((e) => e.toInt())
            .toList();
      }

      if (json['genres'] != null && json['genres'] is List) {
        _genres = (json['genres'] as List)
            .map((e) => e is Map ? (e['name']?.toString() ?? '') : e.toString())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }
  }

  dynamic _id;
  String? _title;
  String? _releaseDate;
  String? _originalLanguage;
  num? _popularity;
  String? _overview;
  num? _voteAverage;
  num? _voteCount;
  String? _posterPath;
  String? _backdropPath;
  List<int>? _genreIds;
  List<String>? _genres;

  dynamic get id => _id;
  String? get title => _title;
  String? get releaseDate => _releaseDate;
  String? get originalLanguage => _originalLanguage;
  num? get popularity => _popularity;
  String? get overview => _overview;
  num? get voteAverage => _voteAverage;
  num? get voteCount => _voteCount;
  String? get posterPath => _posterPath;
  String? get backdropPath => _backdropPath;
  List<int>? get genreIds => _genreIds;
  List<String>? get genres => _genres;

  /// Full URL for the movie poster image
  String? get posterUrl {
    if (_posterPath == null || _posterPath!.isEmpty) return null;
    if (_posterPath!.startsWith('http://') || _posterPath!.startsWith('https://')) {
      return _posterPath;
    }
    return 'https://image.tmdb.org/t/p/w500$_posterPath';
  }

  /// Full URL for the movie backdrop banner image
  String? get backdropUrl {
    if (_backdropPath != null && _backdropPath!.isNotEmpty) {
      if (_backdropPath!.startsWith('http://') || _backdropPath!.startsWith('https://')) {
        return _backdropPath;
      }
      return 'https://image.tmdb.org/t/p/w780$_backdropPath';
    }
    return posterUrl;
  }

  /// Release year formatted as String (e.g., '2024')
  String get year {
    if (_releaseDate == null || _releaseDate!.isEmpty) return 'N/A';
    try {
      final parts = _releaseDate!.split('-');
      if (parts.isNotEmpty && parts[0].length == 4) {
        return parts[0];
      }
    } catch (_) {}
    return _releaseDate!;
  }

  /// Formatted rating (e.g. '8.4')
  String get formattedRating {
    if (_voteAverage == null || _voteAverage == 0) return '7.5';
    return _voteAverage!.toDouble().toStringAsFixed(1);
  }

  /// List of readable genre names
  List<String> get genreNames {
    if (_genres != null && _genres!.isNotEmpty) {
      return _genres!;
    }
    if (_genreIds != null && _genreIds!.isNotEmpty) {
      return _genreIds!.map(_getGenreNameById).where((g) => g.isNotEmpty).toList();
    }
    return ['Featured'];
  }

  static String _getGenreNameById(int id) {
    const genreMap = {
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      14: 'Fantasy',
      36: 'History',
      27: 'Horror',
      10402: 'Music',
      9648: 'Mystery',
      10749: 'Romance',
      878: 'Sci-Fi',
      10770: 'TV Movie',
      53: 'Thriller',
      10752: 'War',
      37: 'Western',
    };
    return genreMap[id] ?? '';
  }

  Items copyWith({
    dynamic id,
    String? title,
    String? releaseDate,
    String? originalLanguage,
    num? popularity,
    String? overview,
    num? voteAverage,
    num? voteCount,
    String? posterPath,
    String? backdropPath,
    List<int>? genreIds,
    List<String>? genres,
  }) =>
      Items(
        id: id ?? _id,
        title: title ?? _title,
        releaseDate: releaseDate ?? _releaseDate,
        originalLanguage: originalLanguage ?? _originalLanguage,
        popularity: popularity ?? _popularity,
        overview: overview ?? _overview,
        voteAverage: voteAverage ?? _voteAverage,
        voteCount: voteCount ?? _voteCount,
        posterPath: posterPath ?? _posterPath,
        backdropPath: backdropPath ?? _backdropPath,
        genreIds: genreIds ?? _genreIds,
        genres: genres ?? _genres,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['release_date'] = _releaseDate;
    map['original_language'] = _originalLanguage;
    map['popularity'] = _popularity;
    map['overview'] = _overview;
    map['vote_average'] = _voteAverage;
    map['vote_count'] = _voteCount;
    map['poster_path'] = _posterPath;
    map['backdrop_path'] = _backdropPath;
    map['genre_ids'] = _genreIds;
    map['genres'] = _genres;
    return map;
  }
}