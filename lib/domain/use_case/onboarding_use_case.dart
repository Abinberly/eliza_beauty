import '../repository/storage_repository.dart';

class CompleteOnboardingUseCase {

  CompleteOnboardingUseCase(this._storage);
  final StorageRepository _storage;

  Future<void> call() async {
    await _storage.saveOnboardingStatus(isComplete: true);
  }
}