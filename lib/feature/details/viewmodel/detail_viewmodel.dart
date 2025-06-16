import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/feature/details/repository/detail_repository.dart';
import 'package:pet_adopt_posha/feature/home/model/pet_model.dart';

final detailRepositoryProvider = Provider<DetailRepository>(
  (ref) => DetailRepository(FirebaseFirestore.instance),
);

final detailViewModelProvider =
    AsyncNotifierProvider.family<DetailViewModel, Pet?, int>(
      DetailViewModel.new,
    );
final isWishlistedProvider = FutureProvider.family.autoDispose<bool, int>((
  ref,
  petId,
) async {
  final repo = ref.read(detailRepositoryProvider);
  final bool isFav = await repo.isFavourited(petId);

  return isFav;
});

class DetailViewModel extends FamilyAsyncNotifier<Pet?, int> {
  late final DetailRepository _repository;
  Pet? _pet;

  @override
  FutureOr<Pet?> build(int id) async {
    _repository = ref.read(detailRepositoryProvider);
    _pet = await _repository.getPetById(id);
    return _pet;
  }

  Future<bool?> adoptPet({required BuildContext context}) async {
    if (_pet == null) return false;

    if (_pet!.isAdopted) {
      _showDialog(context, "Already Adopted");
      return false;
    }

    try {
      await _repository.markPetAsAdopted(_pet!);
      _pet = _pet!.copyWith(isAdopted: true);
      state = AsyncData(_pet);
      return true;
    } catch (e) {
      _showDialog(context, "Adoption failed: $e");
      return false;
    }
  }

  Future<void> toggleWishlist() async {
    if (_pet == null) return;
    log(_pet.toString());
    final isFav = await _repository.isFavourited(_pet!.id);
    if (isFav) {
      await _repository.removeFromFavourites(_pet!.id);
    } else {
      await _repository.addToFavourites(_pet!);
    }
    state = AsyncData(_pet);
  }

  Future<bool> isWishlisted() async {
    if (_pet == null) return false;
    return await _repository.isFavourited(_pet!.id);
  }

  Future<List<Pet>> getAdoptedPets() async {
    return await _repository.getAdoptedPets();
  }

  Future<List<Pet>> getFavouritedPets() async {
    return await _repository.getAdoptedPets();
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Adoption"),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
