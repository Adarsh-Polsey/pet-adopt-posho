import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/feature/history/repository/history_repository.dart';
import 'package:pet_adopt_posha/feature/home/model/pet_model.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});
final historyViewModelProvider = AsyncNotifierProvider<PetListNotifier, List<Pet>>(
  PetListNotifier.new,
);

class PetListNotifier extends AsyncNotifier<List<Pet>> {
  late final HistoryRepository _repo;

  @override
  Future<List<Pet>> build() async {
    _repo = ref.read(historyRepositoryProvider);
    return await _repo.getPetsFromLocalList("adopted_items");
  }
}
