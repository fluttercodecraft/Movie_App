import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_hub/Models/MovieModel.dart';
import 'package:movie_hub/Repositry/movie_Repositry.dart';
import 'package:movie_hub/colors.dart';
import 'package:movie_hub/wigdet/movie_card.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

enum _SearchStatus { initial, loading, error, empty, results }

class _SearchScreenState extends State<SearchScreen> {
  final MovieRepository _repository = MovieRepository();
  late final TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();

  Timer? _debounceTimer;
  List<Items> _searchResults = [];
  _SearchStatus _status = _SearchStatus.initial;
  String? _errorMessage;

  final List<String> _quickSuggestions = [
    'Oppenheimer',
    'Dune',
    'Spider-Man',
    'Batman',
    'Interstellar',
    'Avengers',
    'Gladiator',
    'Avatar',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _performSearch(widget.initialQuery!);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _repository.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _status = _SearchStatus.initial;
        _searchResults = [];
        _errorMessage = null;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _status = _SearchStatus.loading;
      _errorMessage = null;
    });

    try {
      final results = await _repository.searchMovies(query: query);

      if (!mounted) return;

      setState(() {
        _searchResults = results;
        _status = results.isEmpty ? _SearchStatus.empty : _SearchStatus.results;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _status = _SearchStatus.error;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  void _applyQuickSuggestion(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090909),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchInput(),
          _buildQuickSuggestions(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: AnimatedBuilder(
        animation: _searchFocusNode,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _searchFocusNode.hasFocus
                    ? AppColors.primary.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.06),
                width: _searchFocusNode.hasFocus ? 1.4 : 1,
              ),
            ),
            child: child,
          );
        },
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: _onSearchChanged,
          onSubmitted: (query) {
            if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
            _performSearch(query.trim());
          },
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by movie title or keyword...',
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.white54),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white54),
                    onPressed: _clearSearch,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSuggestions() {
    return SizedBox(
      height: 34,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _quickSuggestions.length,
        itemBuilder: (context, index) {
          final term = _quickSuggestions[index];
          final isSelected = _searchController.text.toLowerCase() == term.toLowerCase();

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                term,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: isSelected ? AppColors.primary : const Color(0xFF1E1E1E),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.05),
                ),
              ),
              onPressed: () => _applyQuickSuggestion(term),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _SearchStatus.initial:
        return const Center(
          key: ValueKey('initial'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie_creation_outlined, color: Colors.white24, size: 54),
              SizedBox(height: 16),
              Text(
                'Discover Real Movies',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                'Type a movie title or tap a quick suggestion above.',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ],
          ),
        );

      case _SearchStatus.loading:
        return const Center(
          key: ValueKey('loading'),
          child: CircularProgressIndicator(color: AppColors.primary),
        );

      case _SearchStatus.error:
        return Center(
          key: const ValueKey('error'),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off_rounded, color: Colors.white24, size: 54),
                const SizedBox(height: 16),
                const Text(
                  'Search Encountered an Error',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage ?? 'Unable to connect.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => _performSearch(_searchController.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Retry Search', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );

      case _SearchStatus.empty:
        return Center(
          key: const ValueKey('empty'),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.movie_filter_outlined, color: Colors.white24, size: 54),
                const SizedBox(height: 16),
                const Text(
                  'No Movies Found',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'No results found for "${_searchController.text}". Try another title.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ],
            ),
          ),
        );

      case _SearchStatus.results:
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MovieListItemCard(movie: _searchResults[index]),
            );
          },
        );
    }
  }
}