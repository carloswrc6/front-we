import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbService {
  static final LocalDbService _instance = LocalDbService._();
  LocalDbService._();
  static LocalDbService get instance => _instance;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    print(' dbPath xxx');
    print(dbPath);
    final path = join(dbPath, 'frontwe.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE dishes (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            image TEXT NOT NULL,
            meal_type TEXT NOT NULL,
            country_id TEXT NOT NULL,
            country_code TEXT NOT NULL,
            country_name TEXT NOT NULL,
            ingredients TEXT NOT NULL,
            synced_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE countries (
            id TEXT PRIMARY KEY,
            code TEXT NOT NULL,
            name TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS countries (
              id TEXT PRIMARY KEY,
              code TEXT NOT NULL,
              name TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future<void> clearDishes() async {
    final db = await database;
    await db.delete('dishes');
  }

  Future<void> insertDishes(List<Map<String, dynamic>> rows) async {
    final db = await database;
    final batch = db.batch();
    for (final row in rows) {
      batch.insert('dishes', row, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getAllDishes() async {
    final db = await database;
    return db.query('dishes', orderBy: 'name ASC');
  }

  Future<int> dishCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM dishes');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> clearCountries() async {
    final db = await database;
    await db.delete('countries');
  }

  Future<void> insertCountries(List<Map<String, dynamic>> rows) async {
    final db = await database;
    final batch = db.batch();
    for (final row in rows) {
      batch.insert(
        'countries',
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getAllCountries() async {
    final db = await database;
    return db.query('countries', orderBy: 'name ASC');
  }

  Future<int> countryCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM countries');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
