/// Abstract contract for local storage operations used by domain use cases.
/// The data layer provides the concrete implementation (SecureStorageHelper).
abstract class StorageRepository {
  Future<String?> getAccessToken();
  Future<bool> getOnboardingStatus();
  Future<void> saveOnboardingStatus({required bool isComplete});
}
