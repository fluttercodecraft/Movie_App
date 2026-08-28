import 'package:flutter/material.dart';
import 'package:movie_hub/Models/MovieModel.dart';
import 'package:movie_hub/Repositry/movie_Repositry.dart';
import 'package:movie_hub/Services/movie_api_services.dart';
import 'package:movie_hub/colors.dart';
import 'package:movie_hub/screens/movie_detail_screen.dart';
import 'package:movie_hub/screens/search_screen.dart';
import 'package:movie_hub/wigdet/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _ContentStatus { loading, error, results }

class _HomeScreenState extends State<HomeScreen> {
  final MovieRepository _repository = MovieRepository();

  HomeMovies? _homeMovies;
  _ContentStatus _status = _ContentStatus.loading;
  String? _errorMessage;
  String _selectedGenre = 'All';

  final List<String> _genres = [
    'All',
    'Action',
    'Sci-Fi',
    'Drama',
    'Adventure',
    'Animation',
    'Comedy',
    'Crime',
    'Thriller',
  ];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  Future<void> _loadMovies() async {
    setState(() {
      _status = _ContentStatus.loading;
      _errorMessage = null;
    });

    try {
      final homeData = await _repository.getHomeMovies();
      if (!mounted) return;

      setState(() {
        _homeMovies = homeData;
        _status = _ContentStatus.results;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _status = _ContentStatus.error;
      });
    }
  }

  void _navigateToSearch({String? initialQuery}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(initialQuery: initialQuery),
      ),
    );
  }

  void _showApiKeyDialog() {
    final controller = TextEditingController(text: MovieApiService.apiKey);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'TMDB API Key',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'A built-in demo key & real offline library are active. You can also paste your personal TMDB API key here:',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Enter TMDB API Key',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF121212),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              MovieApiService.customApiKey = controller.text.trim();
              Navigator.pop(ctx);
              _loadMovies();
            },
            child: const Text('Save & Reload', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  List<Items> _getFilteredPopularMovies() {
    if (_homeMovies == null) return [];
    if (_selectedGenre == 'All') return _homeMovies!.popular;

    return _homeMovies!.popular.where((m) {
      return m.genreNames.any((g) => g.toLowerCase() == _selectedGenre.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.movie_filter_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DISCOVER',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'MovieHub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.vpn_key_outlined, color: Colors.white60, size: 20),
            tooltip: 'API Settings',
            onPressed: _showApiKeyDialog,
          ),
          const SizedBox(width: 4),
          Material(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: () => _navigateToSearch(),
              borderRadius: BorderRadius.circular(14),
              child: const SizedBox(
                height: 44,
                width: 44,
                child: Icon(Icons.search_rounded, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Material(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _navigateToSearch(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: Colors.white54, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Search real movies, shows, genres...',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primary,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_status) {
      case _ContentStatus.loading:
        return const Center(
          key: ValueKey('loading'),
          child: CircularProgressIndicator(color: AppColors.primary),
        );

      case _ContentStatus.error:
        return Center(
          key: const ValueKey('error'),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off_rounded, color: Colors.white24, size: 56),
                const SizedBox(height: 16),
                const Text(
                  'Unable to load movies',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage ?? 'Check connection or retry.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loadMovies,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );

      case _ContentStatus.results:
        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: const Color(0xFF181818),
          onRefresh: _loadMovies,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
            children: [
              // Hero Featured Movie Banner
              if (_homeMovies != null && _homeMovies!.featured.isNotEmpty)
                _buildHeroFeaturedSection(_homeMovies!.featured.first),

              const SizedBox(height: 18),

              // Category Filter Pills
              _buildCategoryPills(),

              const SizedBox(height: 20),

              // Trending Now (Horizontal Scroll)
              if (_homeMovies != null && _homeMovies!.trending.isNotEmpty) ...[
                _buildSectionHeader('Trending Now', _homeMovies!.trending.length, () {
                  _navigateToSearch(initialQuery: 'trending');
                }),
                const SizedBox(height: 12),
                SizedBox(
                  height: 275,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _homeMovies!.trending.length,
                    itemBuilder: (context, index) {
                      return MoviePosterCard(
                        movie: _homeMovies!.trending[index],
                        width: 145,
                        height: 215,
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 10),

              // Now Playing (Horizontal Poster List)
              if (_homeMovies != null && _homeMovies!.nowPlaying.isNotEmpty) ...[
                _buildSectionHeader('Now in Theaters', _homeMovies!.nowPlaying.length, null),
                const SizedBox(height: 12),
                SizedBox(
                  height: 275,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _homeMovies!.nowPlaying.length,
                    itemBuilder: (context, index) {
                      return MoviePosterCard(
                        movie: _homeMovies!.nowPlaying[index],
                        width: 145,
                        height: 215,
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 10),

              // Popular Movies / Filtered List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildSectionHeader(
                  _selectedGenre == 'All' ? 'Popular Movies' : '$_selectedGenre Movies',
                  _getFilteredPopularMovies().length,
                  null,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    for (final movie in _getFilteredPopularMovies())
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MovieListItemCard(movie: movie),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Top Rated Movies
              if (_homeMovies != null && _homeMovies!.topRated.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildSectionHeader('All-Time Top Rated', _homeMovies!.topRated.length, null),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      for (final movie in _homeMovies!.topRated)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MovieListItemCard(movie: movie),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
    }
  }

  Widget _buildHeroFeaturedSection(Items movie) {
    final backdropUrl = movie.backdropUrl;
    final rating = movie.formattedRating;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailsScreen(movie: movie),
            ),
          );
        },
        child: Container(
          height: 210,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF1E1E1E),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Backdrop Image
              if (backdropUrl != null)
                Image.network(
                  backdropUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: const Color(0xFF1A1A1A)),
                ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.92),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),

              // Featured Pill in Top Left
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'FEATURED TODAY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Movie Details at bottom
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            movie.title ?? 'Featured Movie',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                                    const SizedBox(width: 3),
                                    Text(
                                      rating,
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                movie.year,
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              if (movie.genreNames.isNotEmpty)
                                Text(
                                  movie.genreNames.first,
                                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded, color: Colors.black, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Explore',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPills() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _genres.length,
        itemBuilder: (context, index) {
          final genre = _genres[index];
          final isSelected = genre == _selectedGenre;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: isSelected ? AppColors.primary : const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    _selectedGenre = genre;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      genre,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, VoidCallback? onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'See All',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$count items',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}