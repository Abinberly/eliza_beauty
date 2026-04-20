import 'package:eliza_beauty/data/local/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'language_local_service.g.dart';

class LanguageLocalService {
  final Database _db;
  LanguageLocalService(this._db);

  Future<void> updateLanguage(String code) async {
    await _db.insert('settings', {
      'key': 'language',
      'value': code,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getLanguage() async {
    final maps = await _db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['language'],
    );
    return maps.isNotEmpty ? maps.first['value'] as String : null;
  }
}

@riverpod 
Future<LanguageLocalService> languageLocalService(LanguageLocalServiceRef ref) async {
  final db = await ref.watch(databaseProvider.future); 
  return LanguageLocalService(db);
}
