import 'dart:convert';
import 'package:pet_adopt_posha/shared/widgets/model/pet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepository {

  HistoryRepository();
  Future<List<Pet>> getPetsFromLocalList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(key) ?? [];

    return existing.map((item) {
      final decoded = jsonDecode(item);
      return Pet.fromJson(decoded);
    }).toList();
  }
}
