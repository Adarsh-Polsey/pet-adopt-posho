import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/feature/home/model/pet_model.dart';
import 'package:pet_adopt_posha/feature/wishlist/repository/wishlist_repository.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepository();
});
final wishlistViewModelProvider =
    AutoDisposeAsyncNotifierProvider<PetListNotifier, List<Pet>>(
      PetListNotifier.new,
    );

class PetListNotifier extends AutoDisposeAsyncNotifier<List<Pet>> {
  late final WishlistRepository _repo;

  @override
  Future<List<Pet>> build() async {
    _repo = ref.read(wishlistRepositoryProvider);
    return await _repo.getPetsFromLocalList("favourite_items");
  }
}
