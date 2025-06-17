import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adopt_posha/config/firestore_exceptions.dart';
import 'package:pet_adopt_posha/shared/widgets/model/pet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailRepository {
  final FirebaseFirestore _firestore;

  DetailRepository(this._firestore);

  Future<Pet?> getPetById(int id) async {
    try {
      final query = await _firestore
          .collection('pets')
          .where('id', isEqualTo: id)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      final doc = query.docs.first;
      final data = doc.data();

      return Pet.fromJson(data);
    } on FirebaseException catch (e) {
      throw FirestoreException('Firestore error: ${e.message}');
    } catch (e) {
      throw FirestoreException('Unexpected error: $e');
    }
  }

  Future<void> markPetAsAdopted(Pet pet) async {
    try {
      final query = await _firestore
          .collection('pets')
          .where('id', isEqualTo: pet.id)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        await _firestore.collection('pets').doc(query.docs.first.id).update({
          'isAdopted': true,
        });
      }
      await markAsAdoptedOffline(pet);
    } catch (e) {
      throw FirestoreException('Error updating adoption status: $e');
    }
  }

  Future<void> _addPetToLocalList(String key, Pet pet) async {
      final prefs = await SharedPreferences.getInstance();
      final existing = prefs.getStringList(key) ?? [];

      final alreadyExists = existing.any((item) {
        final decoded = jsonDecode(item);
        return decoded['id'] == pet.id;
      });

      if (!alreadyExists) {
        final jsonString = jsonEncode(pet.toJson());
        existing.add(jsonString);
        await prefs.setStringList(key, existing);
      }
  }

  Future<void> _removePetFromLocalList(String key, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(key) ?? [];
    existing.removeWhere((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == id;
    });
    await prefs.setStringList(key, existing);
  }

  Future<List<Pet>> _getPetsFromLocalList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(key) ?? [];

    return existing.map((item) {
      final decoded = jsonDecode(item);
      return Pet.fromJson(decoded);
    }).toList();
  }

  Future<bool> _isPetInLocalList(String key, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(key) ?? [];
    return existing.any((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == id;
    });
  }

  Future<void> addToFavourites(Pet pet) async =>
      _addPetToLocalList('favourite_items', pet);
  Future<void> removeFromFavourites(int id) async =>
      _removePetFromLocalList('favourite_items', id);
  Future<bool> isFavourited(int id) async =>
      _isPetInLocalList('favourite_items', id);
  Future<List<Pet>> getFavouritePets() async =>
      _getPetsFromLocalList('favourite_items');

  Future<void> markAsAdoptedOffline(Pet pet) async =>
      _addPetToLocalList('adopted_items', pet);
  Future<bool> isAdopted(int id) async =>
      _isPetInLocalList('adopted_items', id);
  Future<List<Pet>> getAdoptedPets() async =>
      _getPetsFromLocalList('adopted_items');
}
