/// title : "A Man for All Seasons"
/// release_date : "1966-12-13"
/// original_language : "en"
/// popularity : 15.98
/// overview : "A depiction of the conflict between King Henry VIII of England and his Lord Chancellor, Sir Thomas More, who refuses to swear the Oath of Supremacy declaring Henry Supreme Head of the Church in England."
/// vote_average : 7.3
/// vote_count : 387

class MovieService {
  MovieService({
      String? title, 
      String? releaseDate, 
      String? originalLanguage, 
      num? popularity, 
      String? overview, 
      num? voteAverage, 
      num? voteCount,}){
    _title = title;
    _releaseDate = releaseDate;
    _originalLanguage = originalLanguage;
    _popularity = popularity;
    _overview = overview;
    _voteAverage = voteAverage;
    _voteCount = voteCount;
}

  MovieService.fromJson(dynamic json) {
    _title = json['title'];
    _releaseDate = json['release_date'];
    _originalLanguage = json['original_language'];
    _popularity = json['popularity'];
    _overview = json['overview'];
    _voteAverage = json['vote_average'];
    _voteCount = json['vote_count'];
  }
  String? _title;
  String? _releaseDate;
  String? _originalLanguage;
  num? _popularity;
  String? _overview;
  num? _voteAverage;
  num? _voteCount;
MovieService copyWith({  String? title,
  String? releaseDate,
  String? originalLanguage,
  num? popularity,
  String? overview,
  num? voteAverage,
  num? voteCount,
}) => MovieService(  title: title ?? _title,
  releaseDate: releaseDate ?? _releaseDate,
  originalLanguage: originalLanguage ?? _originalLanguage,
  popularity: popularity ?? _popularity,
  overview: overview ?? _overview,
  voteAverage: voteAverage ?? _voteAverage,
  voteCount: voteCount ?? _voteCount,
);
  String? get title => _title;
  String? get releaseDate => _releaseDate;
  String? get originalLanguage => _originalLanguage;
  num? get popularity => _popularity;
  String? get overview => _overview;
  num? get voteAverage => _voteAverage;
  num? get voteCount => _voteCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['release_date'] = _releaseDate;
    map['original_language'] = _originalLanguage;
    map['popularity'] = _popularity;
    map['overview'] = _overview;
    map['vote_average'] = _voteAverage;
    map['vote_count'] = _voteCount;
    return map;
  }

}