import 'package:eliza_beauty/core/local/secure_storage_helper.dart';

class CompleteOnboardingUseCase {
  final SecureStorageHelper _storage;

  CompleteOnboardingUseCase(this._storage);

  Future<void> call() async {
    await _storage.saveOnboardingStatus(isComplete: true);
  }
}