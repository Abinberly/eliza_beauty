import 'package:eliza_beauty/domain/repository/storage_repository.dart';

class CompleteOnboardingUseCase {
  final StorageRepository _storage;

  CompleteOnboardingUseCase(this._storage);

  Future<void> call() async {
    await _storage.saveOnboardingStatus(isComplete: true);
  }
}