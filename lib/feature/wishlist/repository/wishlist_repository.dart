import 'dart:convert';
import 'dart:developer';
import 'package:pet_adopt_posha/feature/home/model/pet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistRepository {
  WishlistRepository();
  Future<List<Pet>> getPetsFromLocalList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    log(key);
    final existing = prefs.getStringList(key) ?? [];

    return existing.map((item) {
      final decoded = jsonDecode(item);
      return Pet.fromJson(decoded);
    }).toList();
  }
}
