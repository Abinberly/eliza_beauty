import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

part 'database_provider.g.dart';

@riverpod
Future<Database> database(DatabaseRef ref) async {
  return await DatabaseHelper.instance.database;
}