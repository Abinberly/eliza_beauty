import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'password_visibility_provider.g.dart';

@riverpod
 class PasswordVisibility extends _$PasswordVisibility {
   
   @override
   bool build(String fieldId) => true;

   void toggle() => state = !state;
 }