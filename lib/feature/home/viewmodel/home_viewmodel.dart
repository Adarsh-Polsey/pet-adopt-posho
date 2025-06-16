import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/config/firestore_exceptions.dart';
import 'package:pet_adopt_posha/feature/home/model/pet_model.dart';
import 'package:pet_adopt_posha/feature/home/repository/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepository(FirebaseFirestore.instance),
);

final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, List<Pet>>(
  HomeViewModel.new,
);
class HomeViewModel extends AsyncNotifier<List<Pet>> {
  late final HomeRepository _repository;
  final List<Pet> _allPets = [];
  String _searchQuery = '';
  String _selectedCategory = 'all';

  @override
  FutureOr<List<Pet>> build() async {
    _repository = ref.read(homeRepositoryProvider);
    return _loadInitialPets();
  }

  Future<List<Pet>> _loadInitialPets() async {
    try {
      final pets = await _repository.fetchPets(category: _selectedCategory);
      _allPets.clear();
      _allPets.addAll(pets);
      return _filterPets(_searchQuery);
    } catch (e) {
      throw FirestoreException('Initial load failed: $e');
    }
  }

  Future<void> loadMorePets() async {
    try {
      final morePets = await _repository.fetchPets(
        isNextPage: true,
        category: _selectedCategory,
      );
      _allPets.addAll(morePets);
      state = AsyncData(_filterPets(_searchQuery));
    } catch (e) {
      state = AsyncError(
        FirestoreException('Pagination failed: $e'),
        StackTrace.current,
      );
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase().trim();
    state = AsyncData(_filterPets(_searchQuery));
  }

  void updateCategory(String newCategory) async {
    _selectedCategory = newCategory.toLowerCase();
    _repository.resetPagination();
    state = const AsyncLoading();
    try {
      final pets = await _repository.fetchPets(category: _selectedCategory);
      _allPets
        ..clear()
        ..addAll(pets);
      state = AsyncData(_filterPets(_searchQuery));
    } catch (e) {
      state = AsyncError(
        FirestoreException('Category change failed: $e'),
        StackTrace.current,
      );
    }
  }

  List<Pet> _filterPets(String query) {
    if (query.isEmpty) return [..._allPets];

    return _allPets
        .where((pet) => pet.name.toLowerCase().contains(query))
        .toList();
  }
}