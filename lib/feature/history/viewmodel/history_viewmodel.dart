import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/feature/history/repository/history_repository.dart';
import 'package:pet_adopt_posha/shared/model/pet_model.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});
final historyViewModelProvider = AutoDisposeAsyncNotifierProvider<PetListNotifier, List<Pet>>(
  PetListNotifier.new,
);

class PetListNotifier extends AutoDisposeAsyncNotifier<List<Pet>> {
  late final HistoryRepository _repo;

  @override
  Future<List<Pet>> build() async {
    _repo = ref.read(historyRepositoryProvider);
    return await _repo.getPetsFromLocalList("adopted_items");
  }
}
