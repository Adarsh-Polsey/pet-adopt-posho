import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adopt_posha/config/firestore_exceptions.dart';
import 'package:pet_adopt_posha/feature/home/model/pet_model.dart';

class HomeRepository {
  final FirebaseFirestore _firestore;
  final int _limit = 20;

  DocumentSnapshot? _lastDoc;

  HomeRepository(this._firestore);

Future<List<Pet>> fetchPets({
  bool isNextPage = false,
  String? category,
}) async {
  try {
    Query query = _firestore.collection('pets').limit(_limit);

    if (category != null && category.toLowerCase() != 'all') {
      query = query.where('category', isEqualTo: category.toLowerCase());
    }

    if (isNextPage && _lastDoc != null) {
      query = query.startAfterDocument(_lastDoc!);
    }

    final querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      _lastDoc = querySnapshot.docs.last;
    }

    return querySnapshot.docs
        .map((doc) => Pet.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  } on FirebaseException catch (e) {
    throw FirestoreException.fromCode(e.code);
  } catch (e) {
    throw FirestoreException('Failed to fetch pets: $e');
  }
}
  void resetPagination() {
    _lastDoc = null;
  }
}