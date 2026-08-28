/// items : [{"title":"Robot Dreams","release_date":"2023-10-20","original_language":"es","popularity":403.498,"overview":"Dog lives in Manhattan and he's tired of being alone. One day he decides to build himself a robot, a companion. Their friendship blossoms, until they become inseparable, to the rhythm of 80's NYC. One summer night, Dog, with great sadness, is forced to abandon Robot at the beach. Will they ever meet again?","vote_average":7.1,"vote_count":43},{"title":"Robots","release_date":"2005-03-10","original_language":"en","popularity":42.19,"overview":"Rodney Copperbottom is a young robot inventor who dreams of making the world a better place, until the evil Ratchet takes over Big Weld Industries. Now, Rodney's dreams – and those of his friends – are in danger of becoming obsolete.","vote_average":6.437,"vote_count":4319},{"title":"Robots","release_date":"2005-03-10","original_language":"en","popularity":42.19,"overview":"Rodney Copperbottom is a young robot inventor who dreams of making the world a better place, until the evil Ratchet takes over Big Weld Industries. Now, Rodney's dreams – and those of his friends – are in danger of becoming obsolete.","vote_average":6.437,"vote_count":4319},{"title":"I, Robot","release_date":"2004-07-15","original_language":"en","popularity":31.434,"overview":"In 2035, where robots are commonplace and abide by the three laws of robotics, a technophobic cop investigates an apparent suicide. Suspecting that a robot may be responsible for the death, his investigation leads him to believe that humanity may be in danger.","vote_average":6.942,"vote_count":11245},{"title":"I, Robot","release_date":"2004-07-15","original_language":"en","popularity":31.434,"overview":"In 2035, where robots are commonplace and abide by the three laws of robotics, a technophobic cop investigates an apparent suicide. Suspecting that a robot may be responsible for the death, his investigation leads him to believe that humanity may be in danger.","vote_average":6.942,"vote_count":11245},{"title":"Robotrix","release_date":"1991-05-31","original_language":"cn","popularity":18.588,"overview":"A mad scientist transfers his mind to a wicked robot, which then embarks on a program of kidnaping, rape and murder, during which a female detective is killed. To fight the robot, the police woman's corpse is then made into a robotrix.","vote_average":5.8,"vote_count":26},{"title":"Robots","release_date":"2023-04-26","original_language":"en","popularity":15.721,"overview":"A womanizer and a gold digger trick people into relationships with illegal robot doubles. When they unwittingly use this scam on each other, their robot doubles fall in love and elope, forcing the duo to team up to hunt them down before the authorities discover their secret.","vote_average":5.688,"vote_count":160},{"title":"Robot Overlords","release_date":"2014-10-18","original_language":"en","popularity":15.486,"overview":"Earth has been conquered by robots from another galaxy and the human survivors must stay in their homes, or risk incineration.","vote_average":4.85,"vote_count":246},{"title":"Doraemon: Nobita and the Robot Kingdom","release_date":"2002-03-09","original_language":"ja","popularity":15.324,"overview":"Doraemon and friends travels into another world via the time machine; where humans and robots are living together. However they soon find out that the Empress of Robot Kingdom was trying to capture robots there and turn them emotionless. As the situation goes tense, our heroes sets out to stop the Empress and her plan.","vote_average":6.9,"vote_count":20}]
/// meta : {"count":9,"current_page":1,"items_per_page":9,"number_of_pages":1}

class MovieModel {
  MovieModel({
      List<Items>? items, 
      Meta? meta,}){
    _items = items;
    _meta = meta;
}

  MovieModel.fromJson(dynamic json) {
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<Items>? _items;
  Meta? _meta;
MovieModel copyWith({  List<Items>? items,
  Meta? meta,
}) => MovieModel(  items: items ?? _items,
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

/// count : 9
/// current_page : 1
/// items_per_page : 9
/// number_of_pages : 1

class Meta {
  Meta({
      num? count, 
      num? currentPage, 
      num? itemsPerPage, 
      num? numberOfPages,}){
    _count = count;
    _currentPage = currentPage;
    _itemsPerPage = itemsPerPage;
    _numberOfPages = numberOfPages;
}

  Meta.fromJson(dynamic json) {
    _count = json['count'];
    _currentPage = json['current_page'];
    _itemsPerPage = json['items_per_page'];
    _numberOfPages = json['number_of_pages'];
  }
  num? _count;
  num? _currentPage;
  num? _itemsPerPage;
  num? _numberOfPages;
Meta copyWith({  num? count,
  num? currentPage,
  num? itemsPerPage,
  num? numberOfPages,
}) => Meta(  count: count ?? _count,
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

/// title : "Robot Dreams"
/// release_date : "2023-10-20"
/// original_language : "es"
/// popularity : 403.498
/// overview : "Dog lives in Manhattan and he's tired of being alone. One day he decides to build himself a robot, a companion. Their friendship blossoms, until they become inseparable, to the rhythm of 80's NYC. One summer night, Dog, with great sadness, is forced to abandon Robot at the beach. Will they ever meet again?"
/// vote_average : 7.1
/// vote_count : 43

class Items {
  Items({
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

  Items.fromJson(dynamic json) {
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
Items copyWith({  String? title,
  String? releaseDate,
  String? originalLanguage,
  num? popularity,
  String? overview,
  num? voteAverage,
  num? voteCount,
}) => Items(  title: title ?? _title,
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