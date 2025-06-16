
class FirestoreException implements Exception {
  final String message;
  const FirestoreException(this.message);

  @override
  String toString() => 'FirestoreException: $message';

  static FirestoreException fromCode(String code) {
    switch (code) {
      case 'permission-denied':
        return FirestoreException(
          'You do not have permission to access this data.',
        );
      case 'unavailable':
        return FirestoreException(
          'Firestore service is currently unavailable.',
        );
      case 'cancelled':
        return FirestoreException('Request was cancelled.');
      case 'deadline-exceeded':
        return FirestoreException('Request took too long to complete.');
      case 'not-found':
        return FirestoreException('Requested document does not exist.');
      case 'aborted':
        return FirestoreException('Request was aborted. Try again.');
      case 'resource-exhausted':
        return FirestoreException('Quota exceeded. Too many requests.');
      case 'unimplemented':
        return FirestoreException('This feature is not implemented on server.');
      case 'internal':
        return FirestoreException('Internal server error.');
      case '':
        return FirestoreException('Internal server error.');
      default:
        return FirestoreException('Something went wrong. [$code]');
    }
  }
}
