import 'package:eliza_beauty/data/local/secure_storage_helper.dart';
import 'package:eliza_beauty/core/router/app_routes.dart';

class InitializationUseCase {
  final SecureStorageHelper _storage;

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
