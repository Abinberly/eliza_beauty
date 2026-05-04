import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'password_visibility_provider.g.dart';

@Riverpod(keepAlive: true)
 class PasswordVisibility extends _$PasswordVisibility {
   
   @override
   bool build(String fieldId) => true;

   void toggle() => state = !state;
 }