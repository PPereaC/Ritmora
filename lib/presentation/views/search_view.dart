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
        ref
            .read(searchSongsProvider.notifier)
            .searchSongsByQuery(value, filter: filter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isTabletOrDesktop(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(top: isDesktop ? 0 : 10),
        child: Column(
          children: [
            !isDesktop
                ? const SizedBox(height: 40)
                : const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity,
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Buscar canciones o videos',
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 14, right: 8),
                        child: Icon(
                          Iconsax.search_normal_outline,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: IconButton(
                                tooltip: 'Limpiar',
                                icon: const Icon(
                                  Iconsax.close_square_outline,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(searchSongsProvider.notifier)
                                      .clearResults();
                                  setState(() {});
                                },
                              ),
                            )
                          : null,
                      filled: true,
                      fillColor:
                          Colors.white.withOpacity(isDesktop ? 0.06 : 0.12),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.18),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.32),
                          width: 1,
                        ),
                      ),
                    ),
                    onChanged: (v) {
                      setState(() {}); // refrescar suffixIcon visible
                      _onSearchChanged(v);
                    },
                    onSubmitted: _onSearchChanged,
                    textInputAction: TextInputAction.search,
                  ),
                ),
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
      ),
    );
  }
}
