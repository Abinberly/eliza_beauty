import '../repository/storage_repository.dart';
import '../../core/router/app_routes.dart';

class InitializationUseCase {

  InitializationUseCase(this._storage);
  final StorageRepository _storage;

  Future<String> call() async {
    try {
      final token = await _storage.getAccessToken();

      return (token != null && token.isNotEmpty)
          ? AppRoutes.home
          : AppRoutes.login;
    } catch (e, _) {
      return AppRoutes.login;
    }
  }
}
