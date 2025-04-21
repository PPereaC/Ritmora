// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../config/utils/responsive.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        final filter = ref.read(searchFilterProvider);
        ref.read(searchSongsProvider.notifier).searchSongsByQuery(value, filter: filter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    bool isDesktop = Responsive.isTabletOrDesktop(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          !isDesktop 
          ? const SizedBox(height: 40)
          : const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar canciones o videos',
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Iconsax.search_normal_outline, color: Colors.white),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Iconsax.close_square_outline, color: Colors.white),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchSongsProvider.notifier).clearResults();
                      },
                    )
                  : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SearchResultsContent(
              searchController: _searchController,
            ),
          ),
        ],
      ),
    );
  }
}