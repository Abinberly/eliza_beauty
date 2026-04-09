import 'package:eliza_beauty/core/network/chopper_client.dart';
import 'package:eliza_beauty/data/sources/auth_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_providers.g.dart';

@riverpod
AuthApiService authApi(Ref ref) {
  return ref.watch(chopperClientProvider).getService<AuthApiService>();
} 