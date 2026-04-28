import 'package:eliza_beauty/domain/repository/storage_repository.dart';
import 'package:eliza_beauty/core/router/app_routes.dart';

class InitializationUseCase {
  final StorageRepository _storage;

  InitializationUseCase(this._storage);

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
