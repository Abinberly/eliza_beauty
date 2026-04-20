import 'package:eliza_beauty/data/local/secure_storage_helper.dart';

class CompleteOnboardingUseCase {
  final SecureStorageHelper _storage;

  CompleteOnboardingUseCase(this._storage);

  Future<void> call() async {
    await _storage.saveOnboardingStatus(isComplete: true);
  }
}