import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/feature/home/view/widgets/category_tabs.dart';
import 'package:pet_adopt_posha/feature/home/view/widgets/header_section.dart';
import 'package:pet_adopt_posha/shared/widgets/petlist_section.dart';
import 'package:pet_adopt_posha/feature/home/viewmodel/home_viewmodel.dart';
import 'package:pet_adopt_posha/shared/widgets/custom_text_field.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with TickerProviderStateMixin {
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(homeViewModelProvider.notifier).loadMorePets();
      }
      final shouldShow = _scrollController.offset > 500;
      if (shouldShow != _showScrollToTop) {
        setState(() => _showScrollToTop = shouldShow);
      }
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final petsState = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.invalidate(homeViewModelProvider);
        },
        child: SafeArea(
          child: Column(
            children: [
              const HeaderSection(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomTextField(
                  hint: 'Search for pets...',
                  controller: _searchTextController,
                  onChange: (text) => ref
                      .read(homeViewModelProvider.notifier)
                      .updateSearchQuery(text ?? ""),
                  focusNode: _searchTextFocusNode,
                ),
              ),
              const SizedBox(height: 24),
              CategoryTabs(
                onCategorySelected: (category) {
                  ref
                      .read(homeViewModelProvider.notifier)
                      .updateCategory(category);
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: PetListSection(
                  petsState: petsState,
                  scrollController: _scrollController,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton.small(
              onPressed: _scrollToTop,
              backgroundColor: theme.primaryColor,
              child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
            )
          : null,
    );
  }
}
